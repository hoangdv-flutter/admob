import 'package:admob/ad_id/ad_id.dart';
import 'package:admob/ads_loader.dart';
import 'package:admob/ext/di.dart';
import 'package:admob/native/native_ads_factory.dart';
import 'package:admob/native/native_loader_listener.dart';
import 'package:flutter_core/data/obj_references.dart';
import 'package:flutter_core/ext/list.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

@lazySingleton
class NativeAdsLoader {
  final AdId adId;

  final loadedNativeAds = appInject<NativeAdsLoaded>();

  final listeners = <ObjectReference<NativeLoaderListener>>[];

  final lock = Lock(reentrant: true);

  NativeAdsLoader(@Named(AdId.namedAdId) this.adId);

  Future<void> fetchAds(String factoryID,
      ObjectReference<NativeLoaderListener> nativeLoaderListener) async {
    if (!appInject<AdsLoader>().isInitial) return;
    await lock.synchronized(() {
      final availableAds = loadedNativeAds.getLoadedAds(factoryID);
      if (availableAds.isNotEmpty) {
        nativeLoaderListener.value?.onAdLoaded?.call(availableAds[0]);
        availableAds.removeFirst();
        return;
      }
      _loadAds(factoryID, nativeLoaderListener);
    });
  }

  Future<void> _loadAds(String factoryID,
      ObjectReference<NativeLoaderListener> nativeLoaderListener) async {
    await lock.synchronized(() async {
      if (listeners.contains(nativeLoaderListener)) return;
      nativeLoaderListener.value?.onAdLoading?.call();
      listeners.add(nativeLoaderListener);
      NativeAd(
              adUnitId: adId.nativeAdUnitID,
              factoryId: factoryID,
              listener: NativeAdListener(
                onAdFailedToLoad: (ad, error) {
                  _onAdFailedToLoad(ad, error, nativeLoaderListener);
                },
                onAdLoaded: (ad) {
                  _onAdLoaded(factoryID, ad as NativeAd, nativeLoaderListener);
                },
              ),
              nativeAdOptions: NativeAdOptions(
                  videoOptions: VideoOptions(
                      startMuted: true, customControlsRequested: false)),
              request: const AdRequest())
          .load();
    });
  }

  Future<void> _onAdLoaded(String factoryID, NativeAd nativeAd,
      ObjectReference<NativeLoaderListener> nativeLoaderListener) async {
    await lock.synchronized(() {
      final availableAds = loadedNativeAds.getLoadedAds(factoryID);
      listeners.remove(nativeLoaderListener);
      if (nativeLoaderListener.value == null) {
        availableAds.add(nativeAd);
        return;
      }
      nativeLoaderListener.value?.onAdLoaded?.call(nativeAd);
    });
  }

  @disposeMethod
  Future<void> dispose() async {
    await lock.synchronized(() {
      loadedNativeAds.dispose();
    });
  }

  Future<void> _onAdFailedToLoad(Ad ad, LoadAdError error,
      ObjectReference<NativeLoaderListener> nativeLoaderListener) async {
    await lock.synchronized(() {
      listeners.remove(nativeLoaderListener);
      nativeLoaderListener.value?.onAdFailedToLoad?.call(error);
      ad.dispose();
    });
  }
}
