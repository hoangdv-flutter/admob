import 'package:admob/ad_id/ad_id.dart';
import 'package:admob/ad_loader_listener.dart';
import 'package:admob/ads_loader.dart';
import 'package:flutter_core/ext/di.dart';
import 'package:admob/full_screen_ads_loader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

@singleton
class RewardInterLoader extends FullScreenAdsLoader<RewardedInterstitialAd> {
  RewardInterLoader(@Named(AdId.namedAdId) this.adId);

  @disposeMethod
  @override
  dispose() {
    _showWhenReady = false;
    super.dispose();
  }

  final AdId adId;

  bool _showWhenReady = false;

  @override
  Future<bool> show({AdLoaderListener? adLoaderListener}) {
    _showWhenReady = true;
    if (appInject<AdsLoader>().isInitial) MobileAds.instance.setAppMuted(false);
    return super.show(adLoaderListener: adLoaderListener);
  }

  @override
  Future<void> onLoad({AdLoaderListener? adLoaderListener}) async {
    _showWhenReady = false;
    await RewardedInterstitialAd.load(
        adUnitId: adId.rewardedInterAdUnitId,
        request: const AdRequest(httpTimeoutMillis: 30000),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            onAdLoaded(ad);
            if (_showWhenReady) {
              show(adLoaderListener: adLoaderListener);
            }
          },
          onAdFailedToLoad: (error) {
            onAdFailedToLoad(adLoaderListener: adLoaderListener);
          },
        ));
  }

  @override
  Future<void> onShow(RewardedInterstitialAd ads,
      {AdLoaderListener? adLoaderListener}) {
    ads.fullScreenContentCallback =
        getFullScreenContentCallback(adLoaderListener: adLoaderListener);
    return ads.show(
      onUserEarnedReward: (ad, reward) {
        FullScreenAdsLoader.isShowing = false;
        adLoaderListener?.onAdConsume?.call();
      },
    );
  }
}
