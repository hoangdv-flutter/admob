import 'dart:async';

import 'package:admob/app_open/app_open_ads_loader.dart';
import 'package:flutter_core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppLifecycleReactor {
  final AppOpenAdsLoader appOpenAdsLoader;

  late final _appStateController = StreamController<AppState>.broadcast();

  Stream<AppState> get appStateStream => _appStateController.stream;

  AppLifecycleReactor(this.appOpenAdsLoader) {
    _listenAppState();
  }

  void _listenAppState() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream.forEach((element) {
      _onAppStateChange(element);
    });
  }

  void _onAppStateChange(AppState state) {
    _appStateController.addSafety(state);
    if (state == AppState.foreground) {
      appOpenAdsLoader.show();
    }
  }

  @disposeMethod
  void dispose() {
    _appStateController.close();
  }
}
