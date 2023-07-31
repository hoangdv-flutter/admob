import 'dart:async';

import 'package:admob/app_open/app_open_ads_loader.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

@singleton
class AdsLoader {
  var isInitial = false;

  final AppOpenAdsLoader _appOpenAdsLoader;

  AdsLoader(this._appOpenAdsLoader) {
    _init();
  }

  Future<void> _init() async {
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: [
          '2F4D0760CC76965FA11B704EB25F30A7',
          '987E51C0FF974F2007128FBAAAAA201A'
        ]));
    await MobileAds.instance.initialize().then((value) {
      isInitial = true;
      _appOpenAdsLoader.loadAd();
    }, onError: (e) {
      isInitial = false;
      return _init();
    }); /*re-initial when failing init*/
  }
}
