part of 'interstitial_ad.dart';

@Singleton(as: InterstitialLoaderHigh)
class InterstitialLoaderHighImpl extends InterstitialLoaderHigh {
  final AdShared _adShared;

  final PremiumHolder _premiumHolder;

  var _currentIndex = 0;

  InterstitialLoaderHighImpl(this._adShared, this._premiumHolder);

  @override
  void checkShowAds() {
    if (!appInject<AdsLoader>().isInitial) {
      return;
    }
    if (!isShowLoad) return;
    isShowLoad = false;
  }

  @override
  Future<void> loadAds(List<String> listAdsID,
      {AdLoaderListener? adLoaderListener}) async {
    isShowLoad = true;
    if (!availableToShow()) {
      adLoaderListener?.onInterPassed?.call();
      return;
    }
    if (_currentIndex >= listAdsID.length) {
      adLoaderListener?.onInterPassed?.call();
      return;
    } else {
      await onLoad(
        currentId: listAdsID[_currentIndex],
        adLoaderListener: AdLoaderListener(onInterPassed: () async {
          _currentIndex += 1;
          await loadAds(listAdsID, adLoaderListener: adLoaderListener);
        }, onAdClosed: () {
          adLoaderListener?.onAdClosed?.call();
        }, onAdFailedToShow: () {
          adLoaderListener?.onAdFailedToShow?.call();
        }),
      );
    }
  }

  @override
  Future<void> showAds() async {}

  Future<void> onLoad(
      {AdLoaderListener? adLoaderListener, required String currentId}) async {
    await InterstitialAd.load(
        adUnitId: currentId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            show(
              ad,
              adLoaderListener: AdLoaderListener(onAdClosed: () {
                adLoaderListener?.onAdClosed?.call();
              }, onAdFailedToShow: () {
                adLoaderListener?.onAdFailedToShow?.call();
              }),
            );
            print("current ads id success $currentId");
          },
          onAdFailedToLoad: (error) {
            print("current ads id error $currentId");
            adLoaderListener?.onInterPassed?.call();
          },
        ));
  }

  Future<void> show(InterstitialAd ads,
      {AdLoaderListener? adLoaderListener}) async {
    ads.fullScreenContentCallback = getFullScreenContentCallback(
      adLoaderListener: AdLoaderListener(onAdClosed: () {
        adLoaderListener?.onAdClosed?.call();
      }, onAdFailedToShow: () {
        adLoaderListener?.onAdFailedToShow?.call();
      }),
    );
    await ads.show();
  }

  FullScreenContentCallback<InterstitialAd> getFullScreenContentCallback(
      {AdLoaderListener? adLoaderListener}) {
    return FullScreenContentCallback(
        onAdFailedToShowFullScreenContent: (ad, error) {
      ad.dispose();
      adLoaderListener?.onAdFailedToShow?.call();
    }, onAdDismissedFullScreenContent: (ad) {
      ad.dispose();
      appInject<AdShared>().lastTimeShowInterAds =
          DateTime.now().millisecondsSinceEpoch;
      adLoaderListener?.onAdClosed?.call();
    }, onAdShowedFullScreenContent: (ad) {
      adLoaderListener?.onAdStartShow?.call();
    }, onAdClicked: (ad) {
      adLoaderListener?.onAdClick?.call();
    });
  }

  bool availableToShow() {
    if (_premiumHolder.isPremium) {
      return false;
    }
    if (!_adShared.canShowInterstitial) {
      return false;
    }
    return true;
  }

  @disposeMethod
  @override
  dispose() {}
}
