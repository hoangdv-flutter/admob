// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:admob/ad_id/ad_helper.dart' as _i10;
import 'package:admob/ad_id/ad_helper_debug.dart' as _i4;
import 'package:admob/ad_id/ad_id.dart' as _i3;
import 'package:admob/ads_loader.dart' as _i7;
import 'package:admob/app_lifecycle_reactor.dart' as _i17;
import 'package:admob/app_open/app_open_ads_loader.dart' as _i11;
import 'package:admob/banner/banner_ads_loader.dart' as _i13;
import 'package:admob/data/firebase_remote_datasource.dart' as _i8;
import 'package:admob/interstitial/interstititial_loader.dart' as _i14;
import 'package:admob/interstitial/reward_interstitial_loader.dart' as _i16;
import 'package:admob/native/native_ads_factory.dart' as _i9;
import 'package:admob/native/native_ads_loader.dart' as _i15;
import 'package:admob/shared/ads_shared.dart' as _i5;
import 'package:flutter_core/data/shared/premium_holder.dart' as _i12;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

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
    gh.singleton<_i5.AdShared>(_i5.AdShared(gh<_i6.SharedPreferences>()));
    gh.singleton<_i7.AdsLoader>(_i7.AdsLoader());
    gh.singleton<_i8.FirebaseRemoteDataSource>(
        _i8.FirebaseRemoteDataSource(gh<_i5.AdShared>()));
    gh.factory<_i9.NativeAdsLoaded>(() => _i9.NativeAdsLoaded());
    gh.factory<_i3.AdId>(
      () => _i10.AdHelper(
        gh<_i3.AdId>(instanceName: 'adIdDebug'),
        gh<_i3.AdId>(instanceName: 'adIdRelease'),
      ),
      instanceName: 'globalAdId',
    );
    gh.singleton<_i11.AppOpenAdsLoader>(
      _i11.AppOpenAdsLoader(
        gh<_i12.PremiumHolder>(),
        gh<_i3.AdId>(instanceName: 'globalAdId'),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i13.BannerAdsLoader>(
        () => _i13.BannerAdsLoader(gh<_i3.AdId>(instanceName: 'globalAdId')));
    gh.lazySingleton<_i14.InterstitialLoader>(
      () => _i14.InterstitialLoader(
        gh<_i5.AdShared>(),
        gh<_i3.AdId>(instanceName: 'globalAdId'),
        gh<_i12.PremiumHolder>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i15.NativeAdsLoader>(
      () => _i15.NativeAdsLoader(gh<_i3.AdId>(instanceName: 'globalAdId')),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i16.RewardInterLoader>(
      _i16.RewardInterLoader(gh<_i3.AdId>(instanceName: 'globalAdId')),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i17.AppLifecycleReactor>(
      _i17.AppLifecycleReactor(gh<_i11.AppOpenAdsLoader>()),
      dispose: (i) => i.dispose(),
    );
    return this;
  }
}
