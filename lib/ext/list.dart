import 'dart:math';

import 'package:admob/presenter/premium_cubit.dart';


extension ListExt<T> on List<T> {


  void insertAd(T Function() itemBuilder, int startIndex, int repeatInterval,
      int maxAds, PremiumCubit premiumCubit) {
    if (premiumCubit.isPremium) return;
    if (length >= startIndex) {
      insert(startIndex, itemBuilder());
    }
    startIndex += repeatInterval;
    var adsCount = 0;
    while (++adsCount < maxAds && startIndex < length) {
      insert(startIndex, itemBuilder());
      startIndex += repeatInterval;
    }
  }
}
