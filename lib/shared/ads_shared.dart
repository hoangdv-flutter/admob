import 'dart:convert';

import 'package:admob/app_open/app_open_ads_loader.dart';
import 'package:admob/banner/banner_config.dart';
import 'package:admob/full_screen_ads_loader.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AdShared {
  final SharedPreferences sharedPreferences;

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

  static const useInterOnBackKey = "useInterOnBack";

  static const hiddenNativeAdsKey = "hiddenNativeAds";

  static const bannerConfigKey = "bannerConfig";

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
      sharedPreferences.getInt(_interstitialGap) ?? 60000;

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

  String get hiddenNativeAdsJson =>
      sharedPreferences.getString(hiddenNativeAdsKey) ?? "[]";

  set hiddenNativeAdsJson(String value) =>
      sharedPreferences.setString(hiddenNativeAdsKey, value);

  Set<String> get hiddenNativeAds =>
      (jsonDecode(hiddenNativeAdsJson) as List<dynamic>).cast<String>().toSet();

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
}
