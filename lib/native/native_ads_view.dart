import 'package:admob/presenter/native_ads_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/data/shared/premium_holder.dart';
import 'package:flutter_core/ext/di.dart';
import 'package:flutter_core/theme/app_theme.dart';
import 'package:flutter_core/util/constant.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

abstract class NativeAdWidget extends StatelessWidget {
  final String nativeAdId;

  const NativeAdWidget(
      {Key? key,
      required this.nativeAdId,
      required this.decoration,
      required this.margin,
      required this.adSize})
      : super(key: key);

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? margin;

  final double adSize;

  @protected
  String get nativeAdFactory;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: appInject<PremiumHolder>().isPremiumStream,
      builder: (context, snapshot) => snapshot.data == true
          ? Container()
          : StreamBuilder(
              builder: (context, snapshot) {
                final adsState = snapshot.data?.state ?? DataState.idle;
                final nativeAd = snapshot.data?.nativeAd;
                return adsState == DataState.error
                    ? Container()
                    : Container(
                        height: adSize,
                        decoration: decoration,
                        padding: EdgeInsets.all(2.w),
                        margin: margin,
                        child: Center(
                          child: adsState == DataState.loading
                              ? buildLoading()
                              : adsState == DataState.error
                                  ? const Text("error")
                                  : adsState == DataState.loaded &&
                                          nativeAd != null
                                      ? AdWidget(ad: nativeAd)
                                      : Container(),
                        ),
                      );
              },
              stream: context
                  .read<NativeAdsCubit>()
                  .loadAds(nativeAdId, nativeAdFactory)
                  .nativeLoaderState,
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
