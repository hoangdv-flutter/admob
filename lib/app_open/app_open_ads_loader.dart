import 'package:admob/ad_id/ad_id.dart';
import 'package:admob/ads_loader.dart';
import 'package:admob/listener/global_listener.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/data/shared/premium_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

@singleton
class AppOpenAdsLoader {
  final PremiumHolder _premiumHolder;

  final AdId adId;

  AppOpenAdsLoader(this._premiumHolder, @Named(AdId.namedAdId) this.adId);

  AppOpenAd? _availableAd;

  final BehaviorSubject<bool> _adShowingState = BehaviorSubject.seeded(false);

  ValueStream<bool> get adShowingState => _adShowingState.stream;

  final _loadOpenAdsAppState = BehaviorSubject<DataState>();

  ValueStream<DataState> get loadOpenAppAdsState => _loadOpenAdsAppState.stream;

  static var isShowing = false;

  var _busy = false;

  bool get availableAd => _availableAd != null;

  final lock = Lock(reentrant: true);

  Future<void> show({Function()? onShowed}) async {
    if (_premiumHolder.isPremium) return;
    if (_availableAd == null) {
      // loadAd();
      return;
    }
    final adShared = appInject<AdShared>();
    if (!adShared.canShowAppOpen) return;
    _availableAd
      ?..fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          isShowing = true;
          _adShowingState.addSafety(true);
          adShared.lastTimeLoadAds = DateTime
              .now()
              .millisecondsSinceEpoch;
          adShared.lastTimeShowAppOpenAds =
              DateTime
                  .now()
                  .millisecondsSinceEpoch;
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          isShowing = false;
          _adShowingState.addSafety(false);
          ad.dispose();
          loadAd();
          onShowed?.call();
          _availableAd = null;
        },
        onAdDismissedFullScreenContent: (ad) {
          isShowing = false;
          _adShowingState.addSafety(false);
          adShared.lastTimeShowAppOpenAds =
              DateTime
                  .now()
                  .millisecondsSinceEpoch;
          onShowed?.call();
          _availableAd = null;
        },
      )
      ..show();
  }

  Future<void> loadAd() async {
    _loadOpenAdsAppState.addSafety(DataState.loading);
    await Future.delayed(Duration(milliseconds: 1000));
    if (_premiumHolder.isPremium) {
      _loadOpenAdsAppState.addSafety(DataState.error);
      return ;
    }
    if (!appInject<AdsLoader>().isInitial) {
      _loadOpenAdsAppState.addSafety(DataState.error);
      return ;
    }
    if (_busy || availableAd) {
      _availableAd = null;
      _loadOpenAdsAppState.addSafety(DataState.error);
      return;
    }
    _busy = true;
    _availableAd = null;
    await AppOpenAd.load(
        adUnitId: adId.appOpenAdUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _availableAd = ad;
            ad.onPaidEvent = GlobalAdListener.onPaidEventCallback;
            _loadOpenAdsAppState.addSafety(DataState.loaded);
          },
          onAdFailedToLoad: (error) {
            print("Open app ads loaded failed ${error.message}");
            _loadOpenAdsAppState.addSafety(DataState.error);
          },
        ));
    _busy = false;
  }

  @disposeMethod
  void dispose() {
    _clearAds();
  }

  void _clearAds() {
    _adShowingState.close();
    _availableAd?.dispose();
    _loadOpenAdsAppState.close();
    _availableAd = null;
  }
}
