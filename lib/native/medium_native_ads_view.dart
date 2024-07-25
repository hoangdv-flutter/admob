import 'package:admob/presenter/native_ads_cubit.dart';
import 'package:admob/presenter/premium_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MediumNativeAdsBanner extends StatefulWidget {
  final Stream<NativeAdLoaderState>? adStreamLoader;

  final double adSize;

  final EdgeInsetsGeometry? margin;

  final EdgeInsetsGeometry? padding;

  const MediumNativeAdsBanner(
      {Key? key,
      this.adStreamLoader,
      required this.adSize,
      this.margin,
      this.padding})
      : super(key: key);

  @override
  State<MediumNativeAdsBanner> createState() => _MediumNativeAdsBannerState();
}

class _MediumNativeAdsBannerState extends BaseState<MediumNativeAdsBanner> {
  late final premiumCubit = PremiumCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: premiumCubit,
      child: StreamBuilder(
        builder: (context, snapshot) =>
            snapshot.data != true ? _buildAds() : Container(),
        stream: premiumCubit.isPremiumStream,
      ),
    );
  }

  StreamBuilder<NativeAdLoaderState> _buildAds() {
    return StreamBuilder(
      builder: (context, snapshot) {
        final adsState = snapshot.data?.state ?? DataState.idle;
        final nativeAd = snapshot.data?.nativeAd;
        return adsState == DataState.error
            ? Container()
            : Container(
                margin: widget.margin,
                padding: widget.padding ?? EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.w))),
                child: SizedBox(
                  height: widget.adSize,
                  child: adsState == DataState.loading
                      ? buildLoading()
                      : adsState == DataState.error
                          ? const Text("error")
                          : adsState == DataState.loaded && nativeAd != null
                              ? AdWidget(ad: nativeAd)
                              : Container(),
                ),
              );
      },
      stream: widget.adStreamLoader,
    );
  }

  Widget buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withAlpha(60),
      highlightColor: Colors.white.withAlpha(40),
      child: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              Container(
                width: 50.w,
                color: Colors.white,
              ),
              SizedBox(
                width: 2.w,
              ),
              Expanded(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 5.h,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                          child: Container(
                        height: 5.h,
                        color: Colors.white,
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    height: 5.w,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Container(
                    height: 5.w,
                    color: Colors.white,
                  ),
                ],
              ))
            ],
          )),
          SizedBox(
            height: 2.h,
          ),
          Container(
            height: 4.h,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.w))),
          )
        ],
      ),
    );
  }
}
