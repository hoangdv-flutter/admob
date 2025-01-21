import 'dart:convert';
import 'dart:io';

import 'package:admob/admob.dart';
import 'package:admob/app_open/app_open_ads_loader.dart';
import 'package:admob/banner/banner_config.dart';
import 'package:admob/full_screen_ads_loader.dart';
import 'package:flutter_core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AdShared {
  final SharedPreferences sharedPreferences;

  static String get _prefix => Platform.isAndroid ? '' : 'ios_';

  static const _lastTimeShowInterAds = "last_time_show_inter_ads";

  static const _lastTimeShowAppOpenAds = "last_time_show_app_open_ads";

  static const _lastTimeLoadAds = "lastTimeLoadAds";

  static const _minGapWaterFloorAds = "minGapWaterFloorAds";

  static const _maxGapWaterFloorAds = "maxGapWaterFloorAds";

  static const _ignoredGapThreshold = "ignoreGapThreshold";

  static const _isMonetization = "isMonetization";

  static const _interstitialGap = "interstitialGap";

  static const _appOpenGap = "appOpenGap";

  static const _fullscreenTimeGap = "fullScreenTimeGap";

  static final useInterOnBackKey = "${_prefix}useInterOnBack";

  static final nativeAdsConfigKey = "${_prefix}nativeConfig";

  static final bannerConfigKey = "${_prefix}bannerConfig";

  static final interSplashEnabledKey = "${_prefix}interSplashEnabled";

  static final fullScreenNativeConfigKey =
      "${_prefix}full_screen_native_ad_config";

  AdShared(this.sharedPreferences);

  int get lastTimeShowInterAds =>
      sharedPreferences.getInt(_lastTimeShowInterAds) ?? 0;

  set lastTimeShowInterAds(value) =>
      sharedPreferences.setInt(_lastTimeShowInterAds, value);

  int get lastTimeShowAppOpenAds =>
      sharedPreferences.getInt(_lastTimeShowAppOpenAds) ?? 0;

  set lastTimeShowAppOpenAds(value) =>
      sharedPreferences.setInt(_lastTimeShowAppOpenAds, value);

  int get lastTimeLoadAds => sharedPreferences.getInt(_lastTimeLoadAds) ?? 0;

  set lastTimeLoadAds(value) =>
      sharedPreferences.setInt(_lastTimeLoadAds, value);

  bool get _canShowFullScreenAds =>
      !FullScreenAdsLoader.isShowing && !AppOpenAdsLoader.isShowing;

  bool get canShowInterstitial {
    return DateTime.now().millisecondsSinceEpoch - lastTimeShowInterAds >
            interstitialGap &&
        DateTime.now().millisecondsSinceEpoch - lastTimeShowAppOpenAds >
            fullScreenTimeGap &&
        _canShowFullScreenAds;
  }

  bool get canShowAppOpen =>
      DateTime.now().millisecondsSinceEpoch - lastTimeShowAppOpenAds >
          appOpenGap &&
      DateTime.now().millisecondsSinceEpoch - lastTimeShowInterAds >
          fullScreenTimeGap &&
      _canShowFullScreenAds;

  int get minGapAds => sharedPreferences.getInt(_minGapWaterFloorAds) ?? 5000;

  set minGapAds(value) => sharedPreferences.setInt(_minGapWaterFloorAds, value);

  int get maxGapAds => sharedPreferences.getInt(_maxGapWaterFloorAds) ?? 30000;

  set maxGapAds(value) => sharedPreferences.setInt(_maxGapWaterFloorAds, value);

  int get maxAdsCanBeFailed =>
      sharedPreferences.getInt(_ignoredGapThreshold) ?? 0;

  set maxAdsCanBeFailed(value) =>
      sharedPreferences.setInt(_ignoredGapThreshold, value);

  bool get isMonetization =>
      sharedPreferences.getBool(_isMonetization) ?? false;

  set isMonetization(value) =>
      sharedPreferences.setBool(_isMonetization, value);

  int get interstitialGap =>
      5000;//sharedPreferences.getInt(_interstitialGap) ?? 60000;

  set interstitialGap(value) =>
      sharedPreferences.setInt(_interstitialGap, value);

  int get appOpenGap => sharedPreferences.getInt(_appOpenGap) ?? 15000;

  set appOpenGap(value) => sharedPreferences.setInt(_appOpenGap, value);

  int get fullScreenTimeGap =>
      sharedPreferences.getInt(_fullscreenTimeGap) ?? 5000;

  set fullScreenTimeGap(value) =>
      sharedPreferences.setInt(_fullscreenTimeGap, value);

  bool get useInterOnBack =>
      sharedPreferences.getBool(useInterOnBackKey) ?? true;

  set useInterOnBack(bool value) =>
      sharedPreferences.setBool(useInterOnBackKey, value);

  String get nativeScreenConfigJson =>
      sharedPreferences.getString(nativeAdsConfigKey) ?? "{}";

  set nativeScreenConfigJson(String value) =>
      sharedPreferences.setString(nativeAdsConfigKey, value);

  Map<String, bool> get nativeScreenConfig {
    if (nativeScreenConfigJson.isEmpty) {
      return {};
    }
    try {
      return (jsonDecode(nativeScreenConfigJson) as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value as bool),
      );
    } catch (e) {
      print('Error decoding JSON: $e');
      return {};
    }
  }


  String get bannerConfigJson =>
      sharedPreferences.getString(bannerConfigKey) ?? "{}";

  set bannerConfigJson(String value) {
    sharedPreferences.setString(bannerConfigKey, value);
    bannerConfigs.clear();
    bannerConfigs.addAll((jsonDecode(value) as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, BannerConfig.fromJson(value)),
    ));
  }

  late final bannerConfigs = <String, BannerConfig>{};

  bool get interSplashEnabled =>
      sharedPreferences.getBool(interSplashEnabledKey) ?? true;

  set interSplashEnabled(bool value) =>
      sharedPreferences.setBool(interSplashEnabledKey, value);

  String? get fullScreenNativeConfigJSON =>
      sharedPreferences.getString(fullScreenNativeConfigKey) ??
      '''
    {
  "fullscreen_native_after_inter": true,
  "duration_in_seconds": 5
}
    ''';

  set fullScreenNativeConfigJSON(String? value) {
    sharedPreferences.setString(fullScreenNativeConfigKey, value?? '''
    {
  "fullscreen_native_after_inter": true,
  "duration_in_seconds": 5
}
    ''');
  }

  FullScreenNativeConfig get fullScreenNativeConfig =>
      fullScreenNativeConfigJSON?.let(
        call: (value) => FullScreenNativeConfig.fromJson(jsonDecode(value)),
      ) ??
      FullScreenNativeConfig.defaultConfig();

  set fullScreenNativeConfig(FullScreenNativeConfig value) {
    sharedPreferences.setString(
        fullScreenNativeConfigKey, jsonEncode(value.toJson()));
  }
}
