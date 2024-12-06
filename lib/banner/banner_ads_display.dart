import 'dart:async';

import 'package:admob/admob.dart';
import 'package:admob/banner/banner_ads_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

enum CollapsibleDirection { top, bottom }

class BannerWidget extends StatefulWidget {
  final String bannerId;
  final CollapsibleDirection? collapsibleDirection;

  const BannerWidget(
      {super.key, this.collapsibleDirection, required this.bannerId});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends BaseState<BannerWidget> {
  late final BannerAdsLoader _bannerAdLoader = appInject<BannerAdsLoader>();

  var showable = false;

  StreamSubscription? _showableSubs;

  late final _nativeNotifier = context.read<NativeAdsNotifier?>();

  late final _premiumCubit = PremiumCubit();

  @override
  void initState() {
    if (_nativeNotifier == null) showable = true;
    _showableSubs = _nativeNotifier?.collapsedNativeAdsState.listen(
      (event) {
        setState(
          () {
            showable = !event;
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!showable)
      return SizedBox(
        width: 0,
        height: 0,
      );
    return BlocProvider.value(
      value: _premiumCubit,
      child: StreamBuilder(
        builder: (context, snapshot) =>
            snapshot.data != true ? _buildAds(context) : Container(),
        stream: _premiumCubit.isPremiumStream,
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
    _premiumCubit.close();
    _showableSubs?.cancel();
    super.dispose();
  }

  Widget _buildAds(BuildContext context) {
    _bannerAdLoader.load(
        extras: widget.collapsibleDirection != null
            ? {"collapsible": "${widget.collapsibleDirection?.name}"}
            : null,
        id: widget.bannerId);
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
      stream: _bannerAdLoader.bannerAd,
    );
  }
}
