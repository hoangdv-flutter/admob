import 'package:admob/ad_id/ad_id.dart';
import 'package:admob/ad_loader_listener.dart';
import 'package:admob/ads_loader.dart';
import 'package:flutter_core/ext/di.dart';
import 'package:admob/full_screen_ads_loader.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:admob/water_flow_manager/water_flow_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class InterstitialLoader extends FullScreenAdsLoader<InterstitialAd> {
  final AdShared _adShared;

  final AdId adID;

  InterstitialLoader(this._adShared, @Named(AdId.namedAdId) this.adID);

  late final flow = WaterFlow(waterFlowIds: [
    adID.interHighAdUnitId,
    adID.interMediumAdUnitId,
    adID.interAllPriceAdUnitId
  ], adShared: _adShared, normalIds: adID.normalInterAdUnitId);

  @override
  void onAdLoaded(InterstitialAd ads) {
    super.onAdLoaded(ads);
    flow.reset();
  }

  @override
  void onAdFailedToLoad({AdLoaderListener? adLoaderListener}) {
    super.onAdFailedToLoad(adLoaderListener: adLoaderListener);
    if (flow.canNext) {
      flow.next();
      load(adLoaderListener: adLoaderListener);
    } else {
      flow.failed();
    }
  }

  @override
  Future<void> onLoad({AdLoaderListener? adLoaderListener}) async {
    await InterstitialAd.load(
        adUnitId: flow.currentId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            onAdLoaded(ad);
          },
          onAdFailedToLoad: (error) {
            onAdFailedToLoad(adLoaderListener: adLoaderListener);
          },
        ));
  }

  @override
  Future<bool> show({AdLoaderListener? adLoaderListener}) async {
    if (_adShared.isPremium) {
      adLoaderListener?.onInterPassed?.call();
      return true;
    }
    if (!_adShared.canShowInterstitial || !flow.validToRequestAds) {
      adLoaderListener?.onInterPassed?.call();
      return false;
    }
    if (appInject<AdsLoader>().isInitial) MobileAds.instance.setAppMuted(true);
    return await super.show(adLoaderListener: adLoaderListener);
  }

  @override
  Future<void> onShow(InterstitialAd ads,
      {AdLoaderListener? adLoaderListener}) {
    ads.fullScreenContentCallback =
        getFullScreenContentCallback(adLoaderListener: adLoaderListener);
    return ads.show();
  }

  @override
  void onLoadNextAds() {
    load();
  }

  @disposeMethod
  @override
  dispose() {
    return super.dispose();
  }
}
