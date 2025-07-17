import 'package:admob/native/native_ads_only_loader.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:flutter_core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'native_ads_presenter_high.dart';

@injectable
class NativeAdsOnlyNotifier extends BaseChangeNotifier {

  final bool useCollapsedNative;

  final  nativeAdLoader = appInject<NativeAdsOnlyLoader>();

  final  adShared = appInject<AdShared>();

  late final nativeConfig = adShared.nativeScreenConfig;

  late final _collapsedNativeAdsState =
  BehaviorSubject.seeded(useCollapsedNative);

  ValueStream<bool> get collapsedNativeAdsState =>
      _collapsedNativeAdsState.stream;

  late final _collapsedNativeSuccess = BehaviorSubject.seeded(true);

  Stream<bool> get collapsedNativeSuccess => _collapsedNativeSuccess.stream;

  Stream<Map<NativeOnlyEnum, NativeAdLoadState>> get stateNativeAdStream => nativeAdLoader.stateNativeAds;

  late final _reloadNativeAds = BehaviorSubject.seeded(false);
  Stream<bool> get reloadNativeAds => _reloadNativeAds.stream;

  NativeAdsOnlyNotifier({this.useCollapsedNative = false});

  void loadAds(NativeOnlyEnum type) {
    nativeAdLoader.preloadNativeAds(type);
  }

  void removeAds(NativeOnlyEnum type) {
    nativeAdLoader.removeNative(type);
    _reloadNativeAds.addSafety(true);
  }

  void toggleShowAds(bool value) => nativeAdLoader.isShow = value;

  NativeAd? fetchNativeAds(NativeOnlyEnum type) {
    _reloadNativeAds.addSafety(false);
    return nativeAdLoader.getAd(type);
  }

  NativeAdLoadState getState(NativeOnlyEnum type) => nativeAdLoader.getState(type);

  void setNativeLoaderState(bool success) {
    _collapsedNativeSuccess.addSafety(success);
    if (!success) {
      _collapsedNativeAdsState.addSafety(false);
    }
  }

  void collapsedNative() {
    _collapsedNativeAdsState.addSafety(false);
  }

  @override
  void dispose() {
    _collapsedNativeAdsState.close();
    _collapsedNativeSuccess.close();
    _reloadNativeAds.close();
    super.dispose();
  }
}