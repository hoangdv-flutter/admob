import 'package:admob/native/native_ads_factory.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/data/shared/premium_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

import '../ads_loader.dart';
import '../listener/global_listener.dart';

enum NativeAdLoadState { idle, loading, loaded, failed }

enum NativeHighEnum {
  langFirst,
  langSecond,
  onboardFirst,
  onboardFullFirst,
  onboardFullSecond
}

extension NativeIDHighExtension on NativeHighEnum {
  List<String> get listID {
    switch (this) {
      case NativeHighEnum.langFirst:
        return kDebugMode
            ? [
                "ca-app-pub-3940256099942544/2247696111",
                "ca-app-pub-3940256099942544/2247696110"
              ]
            : [
                "ca-app-pub-5390451356176712/7125897074",
                "ca-app-pub-5390451356176712/6759614307",
              ];
      case NativeHighEnum.langSecond:
        return kDebugMode
            ? [
                "ca-app-pub-3940256099942544/2247696111",
                "ca-app-pub-3940256099942544/2247696110"
              ]
            : [
                "ca-app-pub-5390451356176712/1048956778",
                "ca-app-pub-5390451356176712/7628459952"
              ];
      case NativeHighEnum.onboardFirst:
        return kDebugMode
            ? [
                "ca-app-pub-3940256099942544/2247696111",
                "ca-app-pub-3940256099942544/2247696110"
              ]
            : [
                "ca-app-pub-5390451356176712/3190274079",
                "ca-app-pub-5390451356176712/2376133276"
              ];
      case NativeHighEnum.onboardFullFirst:
        return kDebugMode
            ? [
                "ca-app-pub-3940256099942544/2247696111",
                "ca-app-pub-3940256099942544/2247696110"
              ]
            : [
                "ca-app-pub-5390451356176712/6577202353",
                "ca-app-pub-5390451356176712/2820369290"
              ];
      case NativeHighEnum.onboardFullSecond:
        return kDebugMode
            ? [
                "ca-app-pub-3940256099942544/2247696111",
                "ca-app-pub-3940256099942544/2247696110"
              ]
            : [
                "ca-app-pub-5390451356176712/3951039014",
                "ca-app-pub-5390451356176712/8749969930"
              ];
    }
  }

  String get nativeID {
    switch (this) {
      case NativeHighEnum.langFirst:
        return "native_language_1_on_off";
      case NativeHighEnum.langSecond:
        return "native_language_2_on_off";
      case NativeHighEnum.onboardFirst:
        return "native_onboarding_1_on_off";
      case NativeHighEnum.onboardFullFirst:
        return "native_full_1_on_off";
      case NativeHighEnum.onboardFullSecond:
        return "native_full_2_on_off";
    }
  }

  String get factoryId {
    switch (this) {
      case NativeHighEnum.langFirst:
        return NativeAdsFactory.nativeTemplateHigh;
      case NativeHighEnum.langSecond:
        return NativeAdsFactory.nativeTemplateHigh;
      case NativeHighEnum.onboardFirst:
        return NativeAdsFactory.nativeTemplateHigh;
      case NativeHighEnum.onboardFullFirst:
        return NativeAdsFactory.fullScreenNativeAdHigh;
      case NativeHighEnum.onboardFullSecond:
        return NativeAdsFactory.fullScreenNativeAdHigh;
    }
  }
}

@singleton
class NativeAdsLoaderHigh {
  final Map<NativeHighEnum, NativeAd?> _nativeAds = {};
  final Map<NativeHighEnum, NativeAdLoadState> _state = {};

  final PremiumHolder premiumHolder;
  final AdShared _adShared;

  NativeAdsLoaderHigh(this.premiumHolder, this._adShared) {
    for (var type in NativeHighEnum.values) {
      _state[type] = NativeAdLoadState.idle;
    }
  }

  void preload(NativeHighEnum type) {
    if (!appInject<AdsLoader>().isInitial) {
      return;
    }
    if (premiumHolder.isPremium ||
        _adShared.nativeScreenConfig[type.nativeID] == false) {
      return;
    }

    final currentState = _state[type];
    if (currentState == NativeAdLoadState.loading ||
        currentState == NativeAdLoadState.loaded) {
      debugPrint('${type.name} already in state $currentState');
      return;
    }

    _state[type] = NativeAdLoadState.loading;

    final ids = type.listID;
    _loadAdWithFallback(type, ids, 0);
  }

  void _loadAdWithFallback(NativeHighEnum type, List<String> ids, int index) {
    if (index >= ids.length) {
      debugPrint('${type.name} all ad units failed.');
      _state[type] = NativeAdLoadState.failed;
      return;
    }

    final adUnitId = ids[index];
    final nativeAd = NativeAd(
      adUnitId: adUnitId,
      factoryId: type.factoryId,
      request: const AdRequest(),
      listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('${type.name} loaded successfully with $adUnitId');
            _nativeAds[type] = ad as NativeAd;
            _state[type] = NativeAdLoadState.loaded;
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('${type.name} failed to load $adUnitId: $error');
            ad.dispose();
            _loadAdWithFallback(type, ids, index + 1);
          },
          onPaidEvent: GlobalAdListener.onPaidEventCallback),
      nativeAdOptions: NativeAdOptions(
          videoOptions:
              VideoOptions(startMuted: true, customControlsRequested: false)),
    );

    nativeAd.load();
  }

  void preloadAll() {
    for (var type in NativeHighEnum.values) {
      preload(type);
    }
  }

  NativeAdLoadState getState(NativeHighEnum type) {
    return _state[type] ?? NativeAdLoadState.idle;
  }

  bool isLoaded(NativeHighEnum type) {
    return _state[type] == NativeAdLoadState.loaded;
  }

  removeNative(NativeHighEnum type) {
    _nativeAds[type]?.dispose();
    _nativeAds.remove(type);
  }

  NativeAd? getAd(NativeHighEnum type) {
    final native = _nativeAds[type];
    return native;
  }

  void disposeAll() {
    for (var ad in _nativeAds.values) {
      ad?.dispose();
    }
    _nativeAds.clear();
  }
}
