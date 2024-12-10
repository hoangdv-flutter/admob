import 'package:flutter_core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

class NativeAdsFactory {
  static const smallNativeBanner = "smallNativeAdView";
  static const mediumNativeBanner = "mediumNativeAdView";
  static const fullScreenNativeAd = "fullScreenNativeAd";
}

@injectable
class NativeAdsLoaded {
  final _loadedAds = <String, List<NativeAd>>{};

  void saveAds(String factoryId, NativeAd nativeAd) {}

  List<NativeAd> getLoadedAds(String factoryID) {
    return _loadedAds[factoryID] ??
        <NativeAd>[].also(
          call: (value) => _loadedAds[factoryID] = value,
        );
  }

  void dispose() {
    _loadedAds.forEach((key, value) {
      for (var element in value) {
        element.dispose();
      }
    });
    _loadedAds.clear();
  }
}
