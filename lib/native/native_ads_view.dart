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
  final bool? fullScreen;

  final Function()? onNativeError;

  final Function()? onNextScreen;

  const NativeAdWidget(
      {Key? key,
      required this.nativeAdId,
      required this.decoration,
      required this.margin,
      required this.adSize,
      this.onNativeError,
      this.onNextScreen,
      required this.fullScreen})
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
        .loadAds(widget.nativeAdId, nativeAdFactory, widget.fullScreen ?? false)
        ?.nativeLoaderState
        .listen((event) {
      setState(() {
        if (event.state == DataState.error) {
          widget.onNativeError?.call();
          onFailedToLoad();
        } else if (event.state == DataState.loaded) {
          onAdLoaded();
        } else if(event.state == DataState.open) {
          onAdOpened();
        }
        adLoaderState = event;
      });
    });
  }

  @protected
  void onFailedToLoad() {}

  @protected
  void onAdLoaded() {}

  @protected
  void onAdOpened() {}

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
                          ? (widget.fullScreen == true
                              ? buildFullScreenAds(nativeAd)
                              : AdWidget(ad: nativeAd))
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

  Widget buildFullScreenAds(NativeAd nativeAd) => Stack(
        children: [
          Positioned.fill(child: AdWidget(ad: nativeAd)),
          buildButtonNext()
        ],
      );

  Widget buildButtonNext() => Container(
        alignment: Alignment.topRight,
        margin: EdgeInsets.all(2.p),
        child: IconButton(
          onPressed: (){
            widget.onNextScreen?.call();
          },
          icon: Container(
            padding: EdgeInsets.symmetric(vertical: 2.p, horizontal: 3.p),
            decoration: BoxDecoration(
              color: Color(0xFF7B5CFA),
              borderRadius: BorderRadius.circular(6.p),
              border: Border.all(color: Color(0xFFEBECF0), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Next",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 1.p),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
}
