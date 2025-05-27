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
  final bool isLarge;

  const BannerWidget(
      {super.key,
      this.collapsibleDirection,
      required this.bannerId, this.isLarge = false});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends BaseState<BannerWidget>
    with WidgetsBindingObserver {
  late final BannerAdsLoader _bannerAdLoader = appInject<BannerAdsLoader>();

  var showable = false;

  var reloadBanner = false;

  StreamSubscription? _showableSubs;

  StreamSubscription? _reloadBannerSub;

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
    _reloadBannerSub = _bannerAdLoader.reloadBanner.listen((value) {
      if (value == true) {
        reloadBanner = true;
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && reloadBanner) {
      reloadBanner = false;
      loadBanner();
    }
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
    _reloadBannerSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void loadBanner() {
    _bannerAdLoader.load(
        extras: widget.collapsibleDirection != null
            ? {"collapsible": "${widget.collapsibleDirection?.name}"}
            : null,
        id: widget.bannerId,
        isLarge: widget.isLarge);
  }

  Widget _buildAds(BuildContext context) {
    loadBanner();
    return StreamBuilder(
      builder: (context, snapshot) => Container(
        color: Colors.white,
        width: double.infinity,
        child: snapshot.hasData
            ? snapshot.data == null
                ? _buildLoading()
                : _buildBanner(snapshot.data!)
            : snapshot.hasError
                ? Container()
                : _buildLoading(),
      ),
      stream: _bannerAdLoader.bannerAd,
    );
  }
}
