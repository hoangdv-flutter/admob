import 'dart:async';
import 'dart:io';

import 'package:admob/app_open/app_open_ads_loader.dart';
import 'package:admob/data/firebase_remote_datasource.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';
import 'package:user_messaging_platform/user_messaging_platform.dart';

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
        final status = await UserMessagingPlatform.instance
            .getTrackingAuthorizationStatus();
        if (status == TrackingAuthorizationStatus.notDetermined) {
          await UserMessagingPlatform.instance.requestTrackingAuthorization();
        }
        await _init();
        AdmobPlatform.instance.notifyConsentDismiss();
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
      '812201C6E5F501E98EA1298F4A034968'
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
