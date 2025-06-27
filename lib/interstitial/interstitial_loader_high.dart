part of 'interstitial_ad.dart';

abstract class InterstitialLoaderHigh {

  bool isShowLoad = true;

  void checkShowAds();

  Future<void> loadAds(List<String> listAdsID, {AdLoaderListener? adLoaderListener});

  Future<void> showAds();

  @protected
  @mustCallSuper
  dispose();
}