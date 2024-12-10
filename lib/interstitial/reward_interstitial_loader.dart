part of 'interstitial_ad.dart';

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
  void onAdLoaded(RewardedInterstitialAd ads) {
    ads.onPaidEvent = GlobalAdListener.onPaidEventCallback;
    super.onAdLoaded(ads);
  }

  @override
  Future<bool> show(
      {BuildContext? context, AdLoaderListener? adLoaderListener}) {
    _showWhenReady = true;
    if (appInject<AdsLoader>().isInitial) MobileAds.instance.setAppMuted(false);
    return super.show(context: context, adLoaderListener: adLoaderListener);
  }

  @override
  Future<void> onLoad({AdLoaderListener? adLoaderListener}) async {
    _showWhenReady = false;
    await RewardedInterstitialAd.load(
        adUnitId: adId.rewardedInterAdUnitId,
        request: const AdRequest(httpTimeoutMillis: 30000),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = getFullScreenContentCallback(
                adLoaderListener: adLoaderListener);
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
    return ads.show(
      onUserEarnedReward: (ad, reward) {
        FullScreenAdsLoader.isShowing = false;
        adLoaderListener?.onAdConsume?.call();
      },
    );
  }
}
