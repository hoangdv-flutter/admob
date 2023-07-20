import 'package:admob/app_open/app_open_ads_loader.dart';
import 'package:admob/full_screen_ads_loader.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AdShared {
  final SharedPreferences sharedPreferences;

  static const _lastTimeShowInterAds = "last_time_show_inter_ads";

  static const _lastTimeShowAppOpenAds = "last_time_show_app_open_ads";

  static const _lastTimeLoadAds = "lastTimeLoadAds";

  static const _minGapWaterFloorAds = "minGapWaterFloorAds";

  static const _maxGapWaterFloorAds = "minGapWaterFloorAds";

  static const _ignoredGapThreshold = "ignoreGapThreshold";

  static const _isMonetization = "isMonetization";

  static const _interstitialGap = "interstitialGap";

  static const _appOpenGap = "appOpenGap";

  static const _fullscreenTimeGap = "fullScreenTimeGap";

  static const _isPremium = "_isPremium";

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
      sharedPreferences.getInt(_interstitialGap) ?? 50000;

  set interstitialGap(value) =>
      sharedPreferences.setInt(_interstitialGap, value);

  int get appOpenGap => sharedPreferences.getInt(_appOpenGap) ?? 15000;

  set appOpenGap(value) => sharedPreferences.setInt(_appOpenGap, value);

  int get fullScreenTimeGap =>
      sharedPreferences.getInt(_fullscreenTimeGap) ?? 5000;

  set fullScreenTimeGap(value) =>
      sharedPreferences.setInt(_fullscreenTimeGap, value);

  bool get isPremium => sharedPreferences.getBool(_isPremium) ?? false;

  set isPremium(value) => sharedPreferences.setInt(_isPremium, value);

  late final _isPremiumBS = BehaviorSubject.seeded(isPremium);

  ValueStream<bool> get isPremiumStream => _isPremiumBS.stream;

  @disposeMethod
  void disposed() {
    _isPremiumBS.close();
  }
}
