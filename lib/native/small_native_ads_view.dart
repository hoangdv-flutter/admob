import 'package:admob/admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/theme/app_theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class SmallNativeAdsWidget extends StatefulWidget {
  final Stream<NativeAdLoaderState>? adStreamLoader;

  const SmallNativeAdsWidget(
      {Key? key, this.adStreamLoader, this.decoration, this.margin})
      : super(key: key);

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? margin;

  @override
  State<SmallNativeAdsWidget> createState() => _SmallNativeAdsWidgetState();
}

class _SmallNativeAdsWidgetState extends BaseState<SmallNativeAdsWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        final adsState = snapshot.data?.state ?? DataState.idle;
        final nativeAd = snapshot.data?.nativeAd;
        return adsState == DataState.error
            ? Container()
            : Container(
                decoration: widget.decoration,
                padding: EdgeInsets.all(2.w),
                margin: widget.margin,
                child: adsState == DataState.loading
                    ? buildLoading()
                    : adsState == DataState.error
                        ? const Text("error")
                        : adsState == DataState.loaded && nativeAd != null
                            ? AdWidget(ad: nativeAd)
                            : Container(),
              );
      },
      stream: widget.adStreamLoader,
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
