import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

@singleton
class AdsLoader {
  var isInitial = false;

  AdsLoader() {
    _init();
  }

  Future<void> _init() async {
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: ['2F4D0760CC76965FA11B704EB25F30A7','987E51C0FF974F2007128FBAAAAA201A']));
    await MobileAds.instance.initialize().then((value) {
      isInitial = true;
    }, onError: (e) {
      isInitial = false;
      return _init();
    }); /*re-initial when failing init*/
  }
}
