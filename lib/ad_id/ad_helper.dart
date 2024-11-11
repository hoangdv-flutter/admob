import 'package:admob/ad_id/ad_id.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@Named(AdId.namedAdId)
@Injectable(as: AdId)
class AdHelper extends AdId {
  static const _forceDebugMode = true;

  final AdId debugAdId;

  final AdId releaseAdId;

  AdHelper(@Named(AdId.namedDebug) this.debugAdId,
      @Named(AdId.namedRelease) this.releaseAdId);

  @override
  String get bannerAdUnitId => (_forceDebugMode || kDebugMode)
      ? debugAdId.bannerAdUnitId
      : releaseAdId.bannerAdUnitId;

  @override
  String get nativeAdUnitID => (_forceDebugMode || kDebugMode)
      ? debugAdId.nativeAdUnitID
      : releaseAdId.nativeAdUnitID;

  @override
  String get interHighAdUnitId => (_forceDebugMode || kDebugMode)
      ? debugAdId.interHighAdUnitId
      : releaseAdId.interHighAdUnitId;

  @override
  String get interMediumAdUnitId => (_forceDebugMode || kDebugMode)
      ? debugAdId.interMediumAdUnitId
      : releaseAdId.interMediumAdUnitId;

  @override
  String get interAllPriceAdUnitId => (_forceDebugMode || kDebugMode)
      ? debugAdId.interAllPriceAdUnitId
      : releaseAdId.interAllPriceAdUnitId;

  @override
  String get normalInterAdUnitId => (_forceDebugMode || kDebugMode)
      ? debugAdId.normalInterAdUnitId
      : releaseAdId.normalInterAdUnitId;

  @override
  String get rewardedAdUnitId => (_forceDebugMode || kDebugMode)
      ? debugAdId.rewardedAdUnitId
      : releaseAdId.rewardedAdUnitId;

  @override
  String get rewardedInterAdUnitId => (_forceDebugMode || kDebugMode)
      ? debugAdId.rewardedInterAdUnitId
      : releaseAdId.rewardedInterAdUnitId;

  @override
  String get appOpenAdUnitId => (_forceDebugMode || kDebugMode)
      ? debugAdId.appOpenAdUnitId
      : releaseAdId.appOpenAdUnitId;
}
