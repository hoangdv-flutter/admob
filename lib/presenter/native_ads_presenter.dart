import 'package:admob/native/native_ads_loader.dart';
import 'package:admob/native/native_loader_listener.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/data/obj_references.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/extension.dart';

part 'collapsed_native_state.dart';

class NativeAdsNotifier extends BaseChangeNotifier {
  final bool useCollapsedNative;

  NativeAdsNotifier({this.useCollapsedNative = false});

  late final nativeLoaderMap = <String, NativeAdRequester>{};

  late final nativeAdLoader = appInject<NativeAdsLoader>();

  late final adShared = appInject<AdShared>();

  late final nativeConfig = adShared.nativeScreenConfig;

  late final _collapsedNativeAdsState =
      BehaviorSubject.seeded(useCollapsedNative);
  ValueStream<bool> get collapsedNativeAdsState =>
      _collapsedNativeAdsState.stream;

  late final _collapsedNativeSuccess = BehaviorSubject.seeded(true);
  Stream<bool> get collapsedNativeSuccess => _collapsedNativeSuccess.stream;

  void setNativeLoaderState(bool success) {
    _collapsedNativeSuccess.addSafety(success);
    if (!success) {
      _collapsedNativeAdsState.addSafety(false);
    }
  }

  NativeAdRequester? loadAds(String requestId, String factoryId) {
    if (nativeConfig[requestId] == false) {
      return null;
    }
    final requester = nativeLoaderMap[requestId] ??
        (NativeAdRequester().also(
          call: (value) => nativeLoaderMap[requestId] = value,
        ));
    if (requester.state != DataState.idle) {
      debugPrint("native ad old State ${requester.state}");
      return requester;
    }
    nativeAdLoader.fetchAds(factoryId, requester.listener);
    return requester;
  }

  void collapsedNative() {
    _collapsedNativeAdsState.addSafety(false);
  }

  @override
  void dispose() {
    _collapsedNativeAdsState.close();
    _collapsedNativeSuccess.close();
    nativeAdLoader.synchronized(() {
      nativeLoaderMap.forEach((key, value) {
        value.close();
      });
      nativeLoaderMap.clear();
    });
    super.dispose();
  }
}

class NativeAdLoaderState {
  final NativeAd? nativeAd;

  void dispose() {
    nativeAd?.dispose();
  }

  final DataState state;

  NativeAdLoaderState({this.nativeAd, required this.state});
}

class NativeAdRequester {
  final _nativeLoaderStateStreamController =
      BehaviorSubject<NativeAdLoaderState>();

  late final listener = ObjectReference(NativeLoaderListener(
    onAdLoaded: (ad) async {
      await Future.delayed(Duration(milliseconds: 1000));
      updateState(NativeAdLoaderState(state: DataState.loaded, nativeAd: ad));
    },
    onAdFailedToLoad: (e) =>
        updateState(NativeAdLoaderState(state: DataState.error)),
    onAdLoading: () =>
        updateState(NativeAdLoaderState(state: DataState.loading)),
  ));

  DataState get state => nativeLoaderState.valueOrNull?.state ?? DataState.idle;

  ValueStream<NativeAdLoaderState> get nativeLoaderState =>
      _nativeLoaderStateStreamController.stream;

  void close() {
    _nativeLoaderStateStreamController.value.nativeAd?.dispose();
    _nativeLoaderStateStreamController.close();
    listener.clearReferences();
  }

  void updateState(NativeAdLoaderState nativeAdLoaderState) {
    if (_nativeLoaderStateStreamController.isClosed) {
      nativeAdLoaderState.nativeAd?.dispose();
      return;
    }
    _nativeLoaderStateStreamController.addSafety(nativeAdLoaderState);
  }
}
