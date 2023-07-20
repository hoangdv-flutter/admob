import 'package:admob/banner/banner_ads_loader.dart';
import 'package:admob/ext/di.dart';
import 'package:admob/presenter/premium_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/index.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends BaseState<BannerWidget> {
  BannerAdsLoader? _bannerAdLoader;

  @override
  Widget build(BuildContext context) {
    final premiumCubit = PremiumCubit();
    _bannerAdLoader?.dispose();
    return BlocProvider(
      create: (context) => premiumCubit,
      lazy: false,
      child: StreamBuilder(
        builder: (context, snapshot) =>
            snapshot.data != true ? _buildAds(context) : Container(),
        stream: premiumCubit.isPremiumStream,
      ),
    );
  }

  Widget _buildBanner(BannerAd data) {
    return SizedBox(
      width: data.size.width.toDouble(),
      height: data.size.height.toDouble(),
      child: AdWidget(ad: data),
    );
  }

  Widget _buildLoading() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.withAlpha(60),
        highlightColor: Colors.white.withAlpha(40),
        child: Container(
          height: AdSize.banner.height.toDouble(),
          padding: EdgeInsets.symmetric(
              vertical: AdSize.banner.height * .05, horizontal: 4.w),
          child: Row(
            children: [
              Container(
                width: 15.w,
                height: double.infinity,
                color: Colors.white,
              ),
              SizedBox(
                width: 2.w,
              ),
              Expanded(
                  child: Container(
                height: double.infinity,
                color: Colors.white,
              ))
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _bannerAdLoader?.dispose();
    super.dispose();
  }

  Widget _buildAds(BuildContext context) {
    _bannerAdLoader = appInject<BannerAdsLoader>();
    return StreamBuilder(
      builder: (context, snapshot) => Container(
        color: Colors.white,
        width: double.infinity,
        child: snapshot.hasData
            ? _buildBanner(snapshot.data!)
            : snapshot.hasError
                ? Container()
                : _buildLoading(),
      ),
      stream: _bannerAdLoader?.bannerAd,
    );
  }
}
