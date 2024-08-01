import 'package:admob/ad_loader_listener.dart';
import 'package:admob/ads_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/ext/di.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'shared/ads_shared.dart';

abstract class FullScreenAdsLoader<T extends Ad> {
  @protected
  bool get needToLoadOnInit => false;

  bool _busy = false;

  var loaderState = DataState.idle;

  var reloadWhenFail = false;

  static bool isShowing = false;

  FullScreenAdsLoader() {
    if (needToLoadOnInit) load();
  }

  T? availableAds;

  void setLoaderState(DataState state) {
    loaderState = state;
  }

  @protected
  FullScreenContentCallback<T> getFullScreenContentCallback(
          {AdLoaderListener? adLoaderListener}) =>
      FullScreenContentCallback(
        onAdFailedToShowFullScreenContent: (ad, error) {
          isShowing = false;
          ad.dispose();
          loaderState = DataState.error;
          adLoaderListener?.onInterPassed?.call();
          adLoaderListener?.onAdFailedToShow?.call();
          onLoadNextAds();
          appInject<AdShared>().lastTimeShowInterAds =
              DateTime.now().millisecondsSinceEpoch;
        },
        onAdDismissedFullScreenContent: (ad) {
          isShowing = false;
          loaderState = DataState.idle;
          adLoaderListener?.onAdClosed?.call();
          adLoaderListener?.onInterPassed?.call();
          ad.dispose();
          availableAds = null;
          onLoadNextAds();
          appInject<AdShared>().lastTimeShowInterAds =
              DateTime.now().millisecondsSinceEpoch;
        },
        onAdShowedFullScreenContent: (ad) {
          adLoaderListener?.onAdStartShow?.call();
        },
      );

  Future<bool> show({AdLoaderListener? adLoaderListener}) async {
    if (availableAds == null) {
      load(adLoaderListener: adLoaderListener);
      adLoaderListener?.onInterPassed?.call();
      return false;
    }
    try {
      isShowing = true;
      await onShow(availableAds as T, adLoaderListener: adLoaderListener);
    } catch (e) {
      isShowing = false;
      try {
        availableAds?.dispose();
      } finally {
        availableAds = null;
      }
      adLoaderListener?.onInterPassed?.call();
    }
    return true;
  }

  @mustCallSuper
  @protected
  void onAdLoaded(T ads) {
    availableAds = ads;
    _busy = false;
  }

  @mustCallSuper
  @protected
  void onAdFailedToLoad({AdLoaderListener? adLoaderListener}) {
    _busy = false;
    adLoaderListener?.onAdFailedToLoad?.call();
  }

  Future<void> load({AdLoaderListener? adLoaderListener}) async {
    if (_busy || !appInject<AdsLoader>().isInitial) return;
    _busy = true;
    await availableAds?.dispose();
    availableAds = null;
    await onLoad(adLoaderListener: adLoaderListener);
  }

  @protected
  Future<void> onLoad({AdLoaderListener? adLoaderListener});

  @protected
  Future<void> onShow(T ads, {AdLoaderListener? adLoaderListener});

  @protected
  @mustCallSuper
  dispose() {
    availableAds?.dispose();
    availableAds = null;
  }

  void onLoadNextAds() {}
}
