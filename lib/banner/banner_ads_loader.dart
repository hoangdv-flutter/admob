import 'dart:async';

import 'package:admob/ad_id/ad_id.dart';
import 'package:admob/ads_loader.dart';
import 'package:admob/listener/global_listener.dart';
import 'package:flutter_core/data/executable.dart';
import 'package:flutter_core/ext/di.dart';
import 'package:flutter_core/ext/stream.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class BannerAdsLoader extends Executable {
  final _bannerAdStreamController = BehaviorSubject<BannerAd?>();

  Stream<BannerAd?> get bannerAd => _bannerAdStreamController.stream;

  BannerAd? _bannerAd;

  final AdId adId;

  BannerAdsLoader(@Named(AdId.namedAdId) this.adId) {
    if (!appInject<AdsLoader>().isInitial) return;
    BannerAd(
            size: AdSize.banner,
            adUnitId: adId.bannerAdUnitId,
            listener: BannerAdListener(
              onAdLoaded: (ad) {
                _bannerAd = ad as BannerAd?;
                _bannerAdStreamController.addSafety(_bannerAd);
              },
              onPaidEvent: GlobalAdListener.onPaidEventCallback,
              onAdFailedToLoad: (ad, error) async {
                ad.dispose();
                _bannerAdStreamController.addErrorSafety(error);
              },
            ),
            request: const AdRequest(httpTimeoutMillis: 30000))
        .load();
  }

  @override
  Future<void> dispose() async {
    _bannerAdStreamController.close();
    _bannerAd?.dispose();
  }
}
