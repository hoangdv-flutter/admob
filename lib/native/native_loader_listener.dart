import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeLoaderListener {
  final Function(NativeAd nativeAd)? onAdLoaded;

  final Function(LoadAdError e)? onAdFailedToLoad;

  final Function()? onAdLoading;

  NativeLoaderListener(
      {this.onAdLoading, this.onAdLoaded, this.onAdFailedToLoad});
}
