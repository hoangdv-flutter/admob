import 'dart:async';

import 'package:admob/ad_id/ad_id.dart';
import 'package:admob/ads_loader.dart';
import 'package:admob/listener/global_listener.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/data/executable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class BannerAdsLoader extends Executable {
  final AdShared adShared;

  final AdId adId;

  BannerAdsLoader(@Named(AdId.namedAdId) this.adId, this.adShared);

  late final configs = adShared.bannerConfigs;

  Stream<BannerAd?> get bannerAd => _bannerAdStreamController.stream;

  final _bannerAdStreamController = BehaviorSubject<BannerAd?>();

  final _reloadBanner = BehaviorSubject.seeded(false);

  Stream<bool> get reloadBanner => _reloadBanner.stream;

  final _adsLoaderStream = BehaviorSubject.seeded(false);

  Stream<bool> get adsLoaderStream => _adsLoaderStream.stream;

  BannerAd? _bannerAd;

  bool _loadable = true;

  void load(
      {required String id, Map<String, String>? extras, bool isLarge = false, String? adID}) {
    _reloadBanner.addSafety(false);
    _adsLoaderStream.addSafety(false);
    if (!appInject<AdsLoader>().isInitial) {
      _adsLoaderStream.addSafety(true);
      return;
    }
    final config = configs[id];
    if (config?.showable == false) {
      _bannerAdStreamController
          .addError(Exception('banner disabled by configuration'));
      return;
    }
    if (!_loadable) return;
    _loadable = false;
    _bannerAdStreamController.addSafety(null);
    BannerAd(
            size: AdSize.banner,
            adUnitId: adID ?? adId.bannerAdUnitId,
            listener: BannerAdListener(
              onAdLoaded: (ad) {
                _loadable = true;
                _bannerAd = ad as BannerAd?;
                _bannerAdStreamController.addSafety(_bannerAd);
              },
              onPaidEvent: GlobalAdListener.onPaidEventCallback,
              onAdFailedToLoad: (ad, error) async {
                _loadable = true;
                ad.dispose();
                _bannerAdStreamController.addErrorSafety(error);
              },
              onAdClicked: (ad) {
                _loadable = true;
                _reloadBanner.addSafety(true);
              },
            ),
            request: AdRequest(
                httpTimeoutMillis: 15000,
                extras: extras?.takeIf(
                      condition: (value) => config?.collapsible != false,
                    ) ??
                    {}))
        .load();
  }

  @override
  Future<void> dispose() async {
    _reloadBanner.close();
    _bannerAdStreamController.close();
    _adsLoaderStream.close();
    _bannerAd?.dispose();
  }
}
