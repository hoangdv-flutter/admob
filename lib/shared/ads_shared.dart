import 'dart:convert';
import 'dart:io';

import 'package:admob/admob.dart';
import 'package:admob/app_open/app_open_ads_loader.dart';
import 'package:admob/banner/banner_config.dart';
import 'package:admob/full_screen_ads_loader.dart';
import 'package:admob/interstitial/interstitial_native_config.dart';
import 'package:flutter_core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AdShared {
  final SharedPreferences sharedPreferences;

  static String get _prefix => Platform.isAndroid ? '' : 'ios_';

  static const _lastTimeShowInterAds = "last_time_show_inter_ads";

  static const _lastTimeShowAppOpenAds = "last_time_show_app_open_ads";

  static const _lastTimeShowReward = "_lastTimeShowReward";

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

  static final adsPlanConfigKey = "adsPlanConfig";

  static final showInterConfigKey = "showInterConfig";

  static final rewardInterGapKey = "rewardInterGap";

  static final maxTimeGapInterPlan2Key = "max_time_gap_2";

  static final fullScreenNativeConfigKey =
      "${_prefix}full_screen_native_ad_config";

  static final interCollapsedNativeConfigKey = "inter_collapsed_native_config";

  static final _percentClickNativeAds = "_percentClickNativeAds";

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

  set lastTimeShowReward(int value) =>
      sharedPreferences.setInt(_lastTimeShowReward, value);

  int get lastTimeShowReward =>
      sharedPreferences.getInt(_lastTimeShowReward) ?? 0;

  bool get _canShowFullScreenAds =>
      !FullScreenAdsLoader.isShowing && !AppOpenAdsLoader.isShowing;

  bool get canShowInterstitial {
    return DateTime.now().millisecondsSinceEpoch - lastTimeShowInterAds >
            (adsPlanConfig == 2 ? interstitialGapPlan2 : interstitialGap) &&
        DateTime.now().millisecondsSinceEpoch - lastTimeShowReward >
            rewardInterGap &&
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
      sharedPreferences.getInt(_interstitialGap) ?? 60000;

  set interstitialGap(value) =>
      sharedPreferences.setInt(_interstitialGap, value);

  int get interstitialGapPlan2 =>
      sharedPreferences.getInt(maxTimeGapInterPlan2Key) ?? 0;

  set interstitialGapPlan2(value) =>
      sharedPreferences.setInt(maxTimeGapInterPlan2Key, value);

  int get appOpenGap => sharedPreferences.getInt(_appOpenGap) ?? 15000;

  set appOpenGap(value) => sharedPreferences.setInt(_appOpenGap, value);

  int get fullScreenTimeGap =>
      sharedPreferences.getInt(_fullscreenTimeGap) ?? 5000;

  set fullScreenTimeGap(value) =>
      sharedPreferences.setInt(_fullscreenTimeGap, value);

  int get rewardInterGap =>
      sharedPreferences.getInt(rewardInterGapKey) ?? 30000;

  set rewardInterGap(value) =>
      sharedPreferences.setInt(rewardInterGapKey, value);

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

  String get interNativeConfigJson => sharedPreferences.getString(interCollapsedNativeConfigKey) ?? "{}";

 set interNativeConfigJson(String value) {
   sharedPreferences.setString(interCollapsedNativeConfigKey, value);
   interNativeConfig.clear();
   interNativeConfig.addAll((jsonDecode(value) as Map<String, dynamic>).map(
         (key, value) => MapEntry(key, InterstitialNativeConfig.fromJson(value)),
   ));
 }

  late final interNativeConfig = <String, InterstitialNativeConfig>{};

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
    sharedPreferences.setString(
        fullScreenNativeConfigKey,
        value ??
            '''
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

  int get adsPlanConfig => sharedPreferences.getInt(adsPlanConfigKey) ?? 2;

  set adsPlanConfig(int value) =>
      sharedPreferences.setInt(adsPlanConfigKey, value);

  String get showInterConfigJson =>
      sharedPreferences.getString(showInterConfigKey) ?? "{}";

  set showInterConfigJson(String value) =>
      sharedPreferences.setString(showInterConfigKey, value);

  Map<String, bool> get showInterConfig {
    if (showInterConfigJson.isEmpty) {
      return {};
    }
    try {
      return (jsonDecode(showInterConfigJson) as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as bool),
      );
    } catch (e) {
      print('Error decoding JSON: $e');
      return {};
    }
  }

  int get percentClickAds => sharedPreferences.getInt(_percentClickNativeAds) ?? 4000;

  set percentClickAds(int value) => sharedPreferences.setInt(_percentClickNativeAds, value);
}
