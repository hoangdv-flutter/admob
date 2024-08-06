import 'package:admob/shared/ads_shared.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_core/data/data_source.dart';
import 'package:flutter_core/ext/app.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseRemoteDataSource extends RemoteDataSource {
  final _remote = FirebaseRemoteConfig.instance;

  static const _interAdsGap = "inter_ads_gap";

  static const _appOpenGap = "inter_and_open_app_gap";

  static const _isMonetization = "is_monetization";

  static const _fullscreenAdsTimeGap = "full_screen_ads_time_gap";

  static const _minTimeGap = "min_time_gap";

  static const _maxTimeGap = "max_time_gap";

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
      AdShared.hiddenNativeAdsKey: shared.hiddenNativeAdsJson,
      AdShared.bannerConfigKey: shared.bannerConfigJson,
    });
    await process(() => _remote.fetchAndActivate());
    shared.isMonetization = _remote.getBool(_isMonetization);
    shared.appOpenGap = _remote.getInt(_appOpenGap);
    shared.interstitialGap = _remote.getInt(_interAdsGap);
    shared.fullScreenTimeGap = _remote.getInt(_fullscreenAdsTimeGap);
    shared.useInterOnBack = _remote.getBool(AdShared.useInterOnBackKey);
    shared.hiddenNativeAdsJson = _remote.getString(AdShared.hiddenNativeAdsKey);
    shared.bannerConfigJson = _remote.getString(AdShared.bannerConfigKey);
  }
}
