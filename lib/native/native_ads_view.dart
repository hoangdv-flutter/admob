import 'dart:async';

import 'package:admob/presenter/native_ads_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/data/shared/premium_holder.dart';
import 'package:flutter_core/theme/app_theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

abstract class NativeAdWidget extends StatefulWidget {
  final String nativeAdId;

  final Function()? onNativeError;

  const NativeAdWidget(
      {Key? key,
      required this.nativeAdId,
      required this.decoration,
      required this.margin,
      required this.adSize,
      this.onNativeError})
      : super(key: key);

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? margin;

  final double adSize;
}

abstract class NativeAdWidgetState extends State<NativeAdWidget> {
  @protected
  String get nativeAdFactory;

  @protected
  StreamSubscription? premiumSubs;

  @protected
  StreamSubscription? nativeStateSubs;

  @protected
  NativeAdLoaderState? adLoaderState;

  @protected
  late final premiumHolder = appInject<PremiumHolder>();

  @protected
  BoxDecoration? get decoration => null;

  @protected
  late final notifier = context.read<NativeAdsNotifier>();

  @override
  void dispose() {
    premiumSubs?.cancel();
    nativeStateSubs?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    initAds();
    super.initState();
  }

  @protected
  void initAds() {
    premiumSubs = appInject<PremiumHolder>().isPremiumStream.listen((event) {
      setState(() {});
    });
    debugPrint("start load Native ad ${widget.nativeAdId}");
    nativeStateSubs = context
        .read<NativeAdsNotifier>()
        .loadAds(widget.nativeAdId, nativeAdFactory)
        ?.nativeLoaderState
        .listen((event) {
      setState(() {
        if (event.state == DataState.error) {
          widget.onNativeError?.call();
          onFailedToLoad();
        } else if (event.state == DataState.loaded) {
          onAdLoaded();
        }
        adLoaderState = event;
      });
    });
  }

  @protected
  void onFailedToLoad() {}

  @protected
  void onAdLoaded() {}

  @override
  Widget build(BuildContext context) {
    if (premiumHolder.isPremium || nativeStateSubs == null) {
      return Container();
    }
    final adsState = adLoaderState?.state ?? DataState.error;
    final nativeAd = adLoaderState?.nativeAd;
    return adsState == DataState.error
        ? Container()
        : Container(
            height: widget.adSize,
            decoration: widget.decoration ?? decoration,
            margin: widget.margin,
            child: Center(
              child: adsState == DataState.loading
                  ? buildLoading()
                  : adsState == DataState.error
                      ? const Text("error")
                      : adsState == DataState.loaded && nativeAd != null
                          ? AdWidget(ad: nativeAd)
                          : Container(),
            ),
          );
  }

  Widget buildLoading() {
    return Shimmer.fromColors(
      baseColor: appColor.colorGrey.withAlpha(60),
      highlightColor: appColor.colorWhite.withAlpha(40),
      child: Column(
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: appColor.colorWhite,
                borderRadius: BorderRadius.all(Radius.circular(8.w))),
          )),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              Container(
                color: appColor.colorWhite,
                width: 10.w,
                height: 3.h,
              ),
              SizedBox(
                width: 2.w,
              ),
              Expanded(
                  child: Container(
                color: Colors.white,
                height: 3.h,
              ))
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 1.h),
            color: appColor.colorWhite,
            height: 3.h,
          ),
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 30.w,
            height: 4.h,
            decoration: BoxDecoration(
                color: appColor.colorWhite,
                borderRadius: BorderRadius.all(Radius.circular(4.w))),
          )
        ],
      ),
    );
  }
}
