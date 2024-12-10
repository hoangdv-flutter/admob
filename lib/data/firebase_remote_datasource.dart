import 'dart:io';

import 'package:admob/shared/ads_shared.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/data/data_source.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseRemoteDataSource extends RemoteDataSource {
  final _remote = FirebaseRemoteConfig.instance;

  static String get _prefix => Platform.isAndroid ? '' : 'ios_';

  static final _interAdsGap = "${_prefix}inter_ads_gap";

  static final _appOpenGap = "${_prefix}inter_and_open_app_gap";

  static final _isMonetization = "${_prefix}is_monetization";

  static final _fullscreenAdsTimeGap = "${_prefix}full_screen_ads_time_gap";

  static final _minTimeGap = "${_prefix}min_time_gap";

  static final _maxTimeGap = "${_prefix}max_time_gap";

  AdShared shared;

  FirebaseRemoteDataSource(this.shared);

  Future<void> fetchConfig() async {
    await _remote.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1)));
    await _remote.setDefaults({
      _interAdsGap: shared.interstitialGap,
      _appOpenGap: shared.appOpenGap,
      _isMonetization: shared.isMonetization,
      _minTimeGap: shared.minGapAds,
      _maxTimeGap: shared.maxGapAds,
      _fullscreenAdsTimeGap: shared.fullScreenTimeGap,
      AdShared.useInterOnBackKey: shared.useInterOnBack,
      AdShared.bannerConfigKey: shared.bannerConfigJson,
      AdShared.interSplashEnabledKey: shared.interSplashEnabled,
      AdShared.nativeAdsConfigKey: shared.nativeScreenConfigJson,
      AdShared.fullScreenNativeConfigKey: shared.fullScreenNativeConfigJSON,
    });
    await process(() => _remote.fetchAndActivate());
    shared.isMonetization = _remote.getBool(_isMonetization);
    shared.appOpenGap = _remote.getInt(_appOpenGap);
    shared.interstitialGap = _remote.getInt(_interAdsGap);
    shared.fullScreenTimeGap = _remote.getInt(_fullscreenAdsTimeGap);
    shared.useInterOnBack = _remote.getBool(AdShared.useInterOnBackKey);
    shared.nativeScreenConfigJson =
        _remote.getString(AdShared.nativeAdsConfigKey);
    shared.bannerConfigJson = _remote.getString(AdShared.bannerConfigKey);
    shared.interSplashEnabled = _remote.getBool(AdShared.interSplashEnabledKey);
    shared.fullScreenNativeConfigJSON =
        _remote.getString(AdShared.fullScreenNativeConfigKey);
  }
}
