import 'dart:async';
import 'dart:io';

import 'package:admob/app_open/app_open_ads_loader.dart';
import 'package:admob/data/firebase_remote_datasource.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

import 'admob_platform_interface.dart';

@singleton
class AdsLoader {
  var isInitial = false;

  final AppOpenAdsLoader _appOpenAdsLoader;

  final FirebaseRemoteDataSource remoteDataSource;

  StreamSubscription? _methodSubs;

  var _initializing = false;

  AdsLoader(this._appOpenAdsLoader, this.remoteDataSource) {
    Future.sync(() async {
      AdmobPlatform.instance.applyMethodChannel();
      if (Platform.isIOS) {
        // final status = await UserMessagingPlatform.instance
        //     .getTrackingAuthorizationStatus();
        // if (status == TrackingAuthorizationStatus.notDetermined) {
        //   await UserMessagingPlatform.instance.requestTrackingAuthorization();
        // }
        Future.sync(
          () async {
            var r = TrackingStatus.notDetermined;
            var total = 0;
            while (true) {
              r = await AppTrackingTransparency.requestTrackingAuthorization();
              if (++total > 5 || r != TrackingStatus.notDetermined) {
                await _init();
                AdmobPlatform.instance.notifyConsentDismiss();
                return;
              }
              await Future.delayed(const Duration(milliseconds: 500));
            }
          },
        );
      } else {
        _methodSubs = AdmobPlatform.instance.onRequestInitAdSdk.listen((event) {
          _init();
        });
      }
    });
  }

  Future<void> _init() async {
    if (_initializing) return;
    _initializing = true;
    await remoteDataSource.fetchConfig();
    MobileAds.instance
        .updateRequestConfiguration(RequestConfiguration(testDeviceIds: [
      '2F4D0760CC76965FA11B704EB25F30A7',
      '987E51C0FF974F2007128FBAAAAA201A',
      '812201C6E5F501E98EA1298F4A034968',
      //IOS
      '6993d6d156ae207d3e53f347357d50db'
      //Hoang iphone 14 pm
    ]));
    await MobileAds.instance.initialize().then((value) {
      isInitial = true;
      _appOpenAdsLoader.loadAd();
    }, onError: (e) {
      isInitial = false;
      return _init();
    }); /*re-initial when failing init*/
  }

  @disposeMethod
  void dispose() {
    _methodSubs?.cancel();
  }
}
