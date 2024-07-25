// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:admob/ad_id/ad_helper.dart' as _i508;
import 'package:admob/ad_id/ad_helper_debug.dart' as _i394;
import 'package:admob/ad_id/ad_id.dart' as _i837;
import 'package:admob/ads_loader.dart' as _i632;
import 'package:admob/app_lifecycle_reactor.dart' as _i1027;
import 'package:admob/app_open/app_open_ads_loader.dart' as _i273;
import 'package:admob/banner/banner_ads_loader.dart' as _i661;
import 'package:admob/data/firebase_remote_datasource.dart' as _i987;
import 'package:admob/interstitial/interstititial_loader.dart' as _i159;
import 'package:admob/interstitial/reward_interstitial_loader.dart' as _i515;
import 'package:admob/native/native_ads_factory.dart' as _i212;
import 'package:admob/native/native_ads_loader.dart' as _i598;
import 'package:admob/shared/ads_shared.dart' as _i484;
import 'package:flutter_core/data/shared/premium_holder.dart' as _i932;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i212.NativeAdsLoaded>(() => _i212.NativeAdsLoaded());
    gh.factory<_i837.AdId>(
      () => _i394.AdHelperDebug(),
      instanceName: 'adIdDebug',
    );
    gh.singleton<_i484.AdShared>(
        () => _i484.AdShared(gh<_i460.SharedPreferences>()));
    gh.factory<_i837.AdId>(
      () => _i508.AdHelper(
        gh<_i837.AdId>(instanceName: 'adIdDebug'),
        gh<_i837.AdId>(instanceName: 'adIdRelease'),
      ),
      instanceName: 'globalAdId',
    );
    gh.singleton<_i515.RewardInterLoader>(
      () => _i515.RewardInterLoader(gh<_i837.AdId>(instanceName: 'globalAdId')),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i661.BannerAdsLoader>(() =>
        _i661.BannerAdsLoader(gh<_i837.AdId>(instanceName: 'globalAdId')));
    gh.singleton<_i987.FirebaseRemoteDataSource>(
        () => _i987.FirebaseRemoteDataSource(gh<_i484.AdShared>()));
    gh.lazySingleton<_i598.NativeAdsLoader>(
      () => _i598.NativeAdsLoader(
        gh<_i837.AdId>(instanceName: 'globalAdId'),
        gh<_i932.PremiumHolder>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i159.InterstitialLoader>(
      () => _i159.InterstitialLoader(
        gh<_i484.AdShared>(),
        gh<_i837.AdId>(instanceName: 'globalAdId'),
        gh<_i932.PremiumHolder>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i273.AppOpenAdsLoader>(
      () => _i273.AppOpenAdsLoader(
        gh<_i932.PremiumHolder>(),
        gh<_i837.AdId>(instanceName: 'globalAdId'),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i632.AdsLoader>(
      () => _i632.AdsLoader(gh<_i273.AppOpenAdsLoader>()),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i1027.AppLifecycleReactor>(
      () => _i1027.AppLifecycleReactor(gh<_i273.AppOpenAdsLoader>()),
      dispose: (i) => i.dispose(),
    );
    return this;
  }
}
