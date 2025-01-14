import 'dart:async';

import 'package:admob/native/native_ads_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class CollapsedNativeAdWidgetState extends NativeAdWidgetState {
  @override
  BoxDecoration? get decoration => BoxDecoration(color: Colors.white);

  var collapsed = false;

  StreamSubscription? _showableSubs;

  @override
  void initAds() {
    if (notifier.nativeConfig[widget.nativeAdId] != false) {
      super.initAds();
    } else {
      notifier.collapsedNative();
    }
    _showableSubs = notifier.collapsedNativeAdsState.listen(
      (event) {
        setState(() {
          collapsed = !event;
        });
      },
    );
    // super.initState();
  }

  @override
  void onFailedToLoad() {
    notifier.setNativeLoaderState(false);
  }

  @override
  void onAdLoaded() {
    notifier.setNativeLoaderState(true);
  }

  @override
  void dispose() {
    _showableSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (premiumHolder.isPremium || nativeStateSubs == null || collapsed) {
      return Container();
    }
    final adsState = adLoaderState?.state ?? DataState.error;
    final nativeAd = adLoaderState?.nativeAd;
    return adsState != DataState.loaded
        ? Container()
        : Container(
            width: 100.w,
            height: widget.adSize,
            decoration: decoration ?? widget.decoration,
            padding: EdgeInsets.all(2.w),
            margin: widget.margin,
            child: adsState == DataState.loading
                ? Center(child: buildLoading())
                : adsState == DataState.error
                    ? const Text("error")
                    : adsState == DataState.loaded && nativeAd != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Padding(
                                  padding: EdgeInsets.all(1.p),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(4.p),
                                        onTap: () => notifier.collapsedNative(),
                                        child: Icon(Icons.expand_more_rounded)),
                                  ),
                                ),
                                Expanded(child: AdWidget(ad: nativeAd))
                              ])
                        : Container(),
          );
  }
}
