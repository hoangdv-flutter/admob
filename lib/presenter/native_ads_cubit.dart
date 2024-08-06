import 'dart:async';

import 'package:admob/shared/ads_shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/ext/di.dart';
import 'package:admob/native/native_ads_loader.dart';
import 'package:admob/native/native_loader_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/data/obj_references.dart';
import 'package:flutter_core/ext/object.dart';
import 'package:flutter_core/ext/stream.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/extension.dart';

class NativeAdsCubit extends Cubit {
  NativeAdsCubit() : super(null);

  late final nativeLoaderMap = <String, NativeAdRequester>{};

  late final nativeAdLoader = appInject<NativeAdsLoader>();

  late final adShared = appInject<AdShared>();

  late final hiddenNativeAds = adShared.hiddenNativeAds;

  NativeAdRequester? loadAds(String requestId, String factoryId) {
    if(hiddenNativeAds.contains(requestId)){
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

  @override
  Future<void> close() async {
    await nativeAdLoader.synchronized(() {
      nativeLoaderMap.forEach((key, value) {
        value.close();
      });
      nativeLoaderMap.clear();
    });
    return await super.close();
  }
}

class NativeAdLoaderState {
  final NativeAd? nativeAd;

  final DataState state;

  NativeAdLoaderState({this.nativeAd, required this.state});
}

class NativeAdRequester {
  final _nativeLoaderStateStreamController =
      BehaviorSubject<NativeAdLoaderState>();

  late final listener = ObjectReference(NativeLoaderListener(
    onAdLoaded: (ad) =>
        updateState(NativeAdLoaderState(state: DataState.loaded, nativeAd: ad)),
    onAdFailedToLoad: (e) =>
        updateState(NativeAdLoaderState(state: DataState.error)),
    onAdLoading: () =>
        updateState(NativeAdLoaderState(state: DataState.loading)),
  ));

  DataState get state => nativeLoaderState.valueOrNull?.state ?? DataState.idle;

  ValueStream<NativeAdLoaderState> get nativeLoaderState =>
      _nativeLoaderStateStreamController.stream;

  void close() {
    _nativeLoaderStateStreamController.close();
    listener.clearReferences();
  }

  void updateState(NativeAdLoaderState nativeAdLoaderState) {
    if (_nativeLoaderStateStreamController.isClosed) return;
    _nativeLoaderStateStreamController.addSafety(nativeAdLoaderState);
  }
}
