part of 'interstitial_ad.dart';

@singleton
class RewardLoader extends FullScreenAdsLoader<RewardedAd> {
  RewardLoader(@Named(AdId.namedAdId) this.adId);

  static const timeoutMillis = 10000;

  @disposeMethod
  @override
  dispose() {
    cancel();
    super.dispose();
  }

  final AdId adId;

  bool _showWhenReady = false;

  @override
  void onAdLoaded(RewardedAd ads) {
    ads.onPaidEvent = GlobalAdListener.onPaidEventCallback;
    super.onAdLoaded(ads);
  }

  @override
  Future<bool> show(
      {BuildContext? context, AdLoaderListener? adLoaderListener}) {
    _showWhenReady = true;
    if (appInject<AdsLoader>().isInitial) MobileAds.instance.setAppMuted(false);
    return super.show(adLoaderListener: adLoaderListener, context: context);
  }

  void cancel() {
    _showWhenReady = false;
  }

  @override
  Future<void> onLoad({AdLoaderListener? adLoaderListener}) async {
    _showWhenReady = true;
    final timer = Timer.periodic(
      const Duration(milliseconds: timeoutMillis),
      (timer) {
        cancel();
        onAdFailedToLoad(adLoaderListener: adLoaderListener);
        timer.cancel();
      },
    );
    await RewardedAd.load(
        adUnitId: adId.rewardedAdUnitId,
        request: const AdRequest(httpTimeoutMillis: timeoutMillis),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            timer.cancel();
            ad.fullScreenContentCallback = getFullScreenContentCallback(
                adLoaderListener: adLoaderListener);
            onAdLoaded(ad);
            if (_showWhenReady) {
              show(adLoaderListener: adLoaderListener);
            }
          },
          onAdFailedToLoad: (error) {
            timer.cancel();
            onAdFailedToLoad(adLoaderListener: adLoaderListener);
          },
        ));
  }

  @override
  Future<void> onShow(RewardedAd ads, {AdLoaderListener? adLoaderListener}) {
    return ads.show(
      onUserEarnedReward: (ad, reward) {
        adLoaderListener?.onAdConsume?.call();
      },
    );
  }
}
