import 'dart:math';

import 'package:admob/shared/ads_shared.dart';
import 'package:flutter_core/core.dart';

class WaterFlow {
  final List<String> waterFlowIds;

  final String normalIds;

  final AdShared adShared;

  static bool forceTurnOffWaterFlow = false;

  var _adsBlockLoaderTime = 0;

  WaterFlow(
      {required this.waterFlowIds,
      required this.normalIds,
      required this.adShared})
      : _adsBlockLoaderTime = adShared.minGapAds;

  var _currentIndex = 0;

  var _timeRequestFailed = 0;

  var _requestFailedTimes = 0;

  String get currentId {
    if (!adShared.isMonetization || forceTurnOffWaterFlow) return normalIds;
    return waterFlowIds[_currentIndex];
  }

  bool get canNext => _currentIndex < waterFlowIds.lastIndex;

  void failed() {
    _requestFailedTimes++;
    _currentIndex = 0;
    _timeRequestFailed = DateTime.now().millisecondsSinceEpoch;

    if (_requestFailedTimes > 1) {
      _adsBlockLoaderTime = min(_adsBlockLoaderTime * 2, adShared.maxGapAds);
    }
  }

  void next() {
    if (!adShared.isMonetization) _currentIndex = 0;
    if (_currentIndex < 0 || _currentIndex > waterFlowIds.lastIndex) return;
    _currentIndex++;
  }

  bool get validToRequestAds {
    if (_requestFailedTimes == 0) return true;
    return DateTime.now().millisecondsSinceEpoch - _timeRequestFailed >
        _adsBlockLoaderTime;
  }

  void reset() {
    _requestFailedTimes = 0;
    _currentIndex = 0;
    _adsBlockLoaderTime = adShared.minGapAds;
    _timeRequestFailed = 0;
  }
}
