import 'package:admob/ad_id/ad_id.dart';
import 'package:admob/ads_loader.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:flutter_core/data/shared/premium_holder.dart';
import 'package:flutter_core/ext/di.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppOpenAdsLoader {
  final PremiumHolder _premiumHolder;

  final AdId adId;

  AppOpenAdsLoader(this._premiumHolder, @Named(AdId.namedAdId) this.adId);

  AppOpenAd? _availableAd;

  static var isShowing = false;

  var _busy = false;

  bool get availableAd => _availableAd != null;

  Future<void> show({Function()? onShowed}) async {
    if (_premiumHolder.isPremium) return;
    if (_availableAd == null) {
      loadAd();
      return;
    }
    final adShared = appInject<AdShared>();
    if (!adShared.canShowAppOpen) return;
    _availableAd
      ?..fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          isShowing = true;
          adShared.lastTimeLoadAds = DateTime.now().millisecondsSinceEpoch;
          adShared.lastTimeShowAppOpenAds =
              DateTime.now().millisecondsSinceEpoch;
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          isShowing = false;
          ad.dispose();
          loadAd();
          onShowed?.call();
          _availableAd = null;
        },
        onAdDismissedFullScreenContent: (ad) {
          isShowing = false;
          adShared.lastTimeShowAppOpenAds =
              DateTime.now().millisecondsSinceEpoch;
          onShowed?.call();
          _availableAd = null;
        },
      )
      ..show();
  }

  Future<void> loadAd() async {
    if (_premiumHolder.isPremium) return;
    if (!appInject<AdsLoader>().isInitial) return;
    if (_busy || availableAd) return;
    _busy = true;
    _availableAd = null;
    await AppOpenAd.load(
        adUnitId: adId.appOpenAdUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) => _availableAd = ad,
          onAdFailedToLoad: (error) {},
        ),
        orientation: AppOpenAd.orientationPortrait);
    _busy = false;
  }

  @disposeMethod
  void dispose() {
    _clearAds();
  }

  void _clearAds() {
    _availableAd?.dispose();
    _availableAd = null;
  }
}
