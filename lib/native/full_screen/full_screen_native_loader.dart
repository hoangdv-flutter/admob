import 'dart:async';

import 'package:admob/ad_id/ad_id.dart';
import 'package:admob/ad_loader_listener.dart';
import 'package:admob/admob.dart';
import 'package:admob/listener/global_listener.dart';
import 'package:admob/native/native_ads_factory.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

part 'full_screen_native_config.dart';
part 'full_screen_native_screen.dart';
part 'full_screen_native_view.dart';
part 'presenter/full_screen_native_notifier.dart';

@singleton
class FullScreenNativeLoader {
  final AdId adId;

  final AdShared adShared;

  FullScreenNativeLoader(@Named(AdId.namedAdId) this.adId, this.adShared);

  final lock = Lock(reentrant: true);

  var _loading = false;

  NativeAd? nativeAd;

  Future<void> show(BuildContext context,
      {AdLoaderListener? adLoaderListener}) async {
    if (nativeAd != null) {
      await context.pushScreen(FullScreenNativeScreen.newRoute(nativeAd!));
      adLoaderListener?.onInterPassed?.call();
      adShared.lastTimeShowInterAds = DateTime.now().millisecondsSinceEpoch;
      _clearNativeAd();
      fetchAd();
    } else {
      adLoaderListener?.onInterPassed?.call();
      fetchAd();
    }
  }

  void _clearNativeAd() {
    nativeAd?.dispose();
    nativeAd = null;
  }

  void fetchAd() {
    if (_loading || nativeAd != null) return;
    _loading = true;
    NativeAd(
            adUnitId: adId.fullScreenNativeId,
            factoryId: NativeAdsFactory.fullScreenNativeAd,
            listener: NativeAdListener(
                onAdFailedToLoad: (ad, error) {
                  _loading = false;
                },
                onAdLoaded: (ad) {
                  nativeAd = ad as NativeAd;
                  _loading = false;
                },
                onPaidEvent: GlobalAdListener.onPaidEventCallback),
            nativeAdOptions: NativeAdOptions(
                mediaAspectRatio: MediaAspectRatio.portrait,
                videoOptions: VideoOptions(
                    startMuted: true, customControlsRequested: false)),
            request: const AdRequest())
        .load();
  }

  @disposeMethod
  void dispose() {
    _clearNativeAd();
  }
}
