import 'dart:async';

import 'package:admob/app_open/app_open_ads_loader.dart';
import 'package:admob/banner/banner_ads_loader.dart';
import 'package:admob/presenter/premium_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/ext/di.dart';
import 'package:flutter_core/index.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class CollapsedBannerWidget extends StatefulWidget {
  const CollapsedBannerWidget({super.key});

  @override
  State<CollapsedBannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends BaseState<CollapsedBannerWidget> {
  final BannerAdsLoader _bannerAdLoader = appInject<BannerAdsLoader>();

  var needToShow = true;

  StreamSubscription? _appOpenShowingSubs;

  @override
  void initState() {
    super.initState();
    _appOpenShowingSubs =
        appInject<AppOpenAdsLoader>().adShowingState.listen((event) {
      setState(() {
        needToShow = !event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!needToShow) {
      print("Banner Show Container");
      return Container();
    } else {
      print("Banner Show Ads");
    }
    final premiumCubit = PremiumCubit();
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
    _bannerAdLoader.dispose();
    _appOpenShowingSubs?.cancel();
    super.dispose();
  }

  Widget _buildAds(BuildContext context) {
    _bannerAdLoader.load(extras: {"collapsible": "bottom"});
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
