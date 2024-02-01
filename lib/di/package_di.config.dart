// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:admob/ad_id/ad_helper.dart' as _i5;
import 'package:admob/ad_id/ad_helper_debug.dart' as _i4;
import 'package:admob/ad_id/ad_id.dart' as _i3;
import 'package:admob/ads_loader.dart' as _i16;
import 'package:admob/app_lifecycle_reactor.dart' as _i17;
import 'package:admob/app_open/app_open_ads_loader.dart' as _i8;
import 'package:admob/banner/banner_ads_loader.dart' as _i10;
import 'package:admob/data/firebase_remote_datasource.dart' as _i11;
import 'package:admob/interstitial/interstititial_loader.dart' as _i12;
import 'package:admob/interstitial/reward_interstitial_loader.dart' as _i15;
import 'package:admob/native/native_ads_factory.dart' as _i13;
import 'package:admob/native/native_ads_loader.dart' as _i14;
import 'package:admob/shared/ads_shared.dart' as _i6;
import 'package:flutter_core/data/shared/premium_holder.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i7;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.AdId>(
      () => _i4.AdHelperDebug(),
      instanceName: 'adIdDebug',
    );
    gh.factory<_i3.AdId>(
      () => _i5.AdHelper(
        gh<_i3.AdId>(instanceName: 'adIdDebug'),
        gh<_i3.AdId>(instanceName: 'adIdRelease'),
      ),
      instanceName: 'globalAdId',
    );
    gh.singleton<_i6.AdShared>(_i6.AdShared(gh<_i7.SharedPreferences>()));
    gh.singleton<_i8.AppOpenAdsLoader>(
      _i8.AppOpenAdsLoader(
        gh<_i9.PremiumHolder>(),
        gh<_i3.AdId>(instanceName: 'globalAdId'),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i10.BannerAdsLoader>(
        () => _i10.BannerAdsLoader(gh<_i3.AdId>(instanceName: 'globalAdId')));
    gh.singleton<_i11.FirebaseRemoteDataSource>(
        _i11.FirebaseRemoteDataSource(gh<_i6.AdShared>()));
    gh.lazySingleton<_i12.InterstitialLoader>(
      () => _i12.InterstitialLoader(
        gh<_i6.AdShared>(),
        gh<_i3.AdId>(instanceName: 'globalAdId'),
        gh<_i9.PremiumHolder>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i13.NativeAdsLoaded>(() => _i13.NativeAdsLoaded());
    gh.lazySingleton<_i14.NativeAdsLoader>(
      () => _i14.NativeAdsLoader(
        gh<_i3.AdId>(instanceName: 'globalAdId'),
        gh<_i9.PremiumHolder>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i15.RewardInterLoader>(
      _i15.RewardInterLoader(gh<_i3.AdId>(instanceName: 'globalAdId')),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i16.AdsLoader>(
      _i16.AdsLoader(gh<_i8.AppOpenAdsLoader>()),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i17.AppLifecycleReactor>(
      _i17.AppLifecycleReactor(gh<_i8.AppOpenAdsLoader>()),
      dispose: (i) => i.dispose(),
    );
    return this;
  }
}
