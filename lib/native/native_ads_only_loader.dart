
import 'package:admob/native/native_ads_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_core/data/shared/premium_holder.dart';
import 'package:flutter_core/ext/exts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../ads_loader.dart';
import '../listener/global_listener.dart';
import '../presenter/native_ads_presenter_high.dart';
import '../shared/ads_shared.dart';

part 'enum/native_only_enum.dart';

@lazySingleton
class NativeAdsOnlyLoader {

  final PremiumHolder _premiumHolder;
  final AdShared _adShared;

  final Map<NativeOnlyEnum, NativeAd?> _nativeAds = {};
  final Map<NativeOnlyEnum, NativeAdLoadState> _state = {};

  late final _stateNativeAds = BehaviorSubject.seeded(_state);
  ValueStream<Map<NativeOnlyEnum, NativeAdLoadState>> get stateNativeAds => _stateNativeAds.stream;

  var isShow = false;

  NativeAdsOnlyLoader(this._premiumHolder, this._adShared) {
    for (var type in NativeOnlyEnum.values) {
      _state[type] = NativeAdLoadState.idle;
    }
    _stateNativeAds.addSafety({..._state});
  }

  void preloadNativeAds(NativeOnlyEnum type) {
    if (!appInject<AdsLoader>().isInitial) {
      _state[type] = NativeAdLoadState.failed;
      _stateNativeAds.addSafety({..._state});
      return;
    }
    if (_premiumHolder.isPremium ||
        _adShared.nativeScreenConfig[type.nativeId] == false) {
      _state[type] = NativeAdLoadState.failed;
      _stateNativeAds.addSafety({..._state});
      return;
    }

    final currentState = _state[type];
    if (currentState == NativeAdLoadState.loading ||
        currentState == NativeAdLoadState.loaded) {
      debugPrint('${type.name} already in state $currentState');
      return;
    }

    _state[type] = NativeAdLoadState.loading;
    _stateNativeAds.addSafety({..._state});
    _loadNativeAds(type);
  }

  void _loadNativeAds(NativeOnlyEnum type) {
    final nativeAd = NativeAd(
      adUnitId: type.adsID,
      factoryId: type.factoryID,
      request: const AdRequest(),
      listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('${type.name} loaded successfully with ${type.adsID}');
            _nativeAds[type] =  ad as NativeAd;
            _state[type] = NativeAdLoadState.loaded;
            _stateNativeAds.addSafety({..._state});
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('${type.name} failed to load ${type.adsID}: $error');
            ad.dispose();
            _state[type] = NativeAdLoadState.failed;
            _stateNativeAds.addSafety({..._state});
          },
          onPaidEvent: GlobalAdListener.onPaidEventCallback),
      nativeAdOptions: NativeAdOptions(
          videoOptions:
          VideoOptions(startMuted: true, customControlsRequested: false)),
    );
    nativeAd.load();
  }

  removeNative(NativeOnlyEnum type) {
    _nativeAds[type]?.dispose();
    _nativeAds.remove(type);
    _state[type] = NativeAdLoadState.idle;
  }

  NativeAd? getAd(NativeOnlyEnum type) {
    if (isShow == false) return null;
    final native = _nativeAds[type];
    // _nativeAds.remove(type);
    return native;
  }

  NativeAdLoadState getState(NativeOnlyEnum type) {
    return _state[type] ?? NativeAdLoadState.idle;
  }

  bool isLoaded(NativeOnlyEnum type) {
    return _state[type] == NativeAdLoadState.loaded;
  }

  void disposeAll() {
    for (var ad in _nativeAds.values) {
      ad?.dispose();
    }
    _nativeAds.clear();
    _stateNativeAds.close();
  }
}