import 'package:flutter_core/data/shared/premium_holder.dart';
import 'package:flutter_core/ext/di.dart';

extension ListExt<T> on List<T> {
  void insertAd(T Function() itemBuilder, int startIndex, int repeatInterval,
      int maxAds) {
    final premiumHolder = appInject<PremiumHolder>();
    if (premiumHolder.isPremium) return;
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
