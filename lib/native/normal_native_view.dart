import 'dart:async';

import 'package:admob/native/native_ads_view.dart';
import 'package:admob/presenter/native_ads_presenter.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/data/shared/premium_holder.dart';
import 'package:provider/provider.dart';

abstract class NormalNativeAdState extends NativeAdWidgetState {
  StreamSubscription? collapsedStateSub;

  @override
  void dispose() {
    collapsedStateSub?.cancel();
    super.dispose();
  }

  @override
  void initAds() {
    premiumSubs = appInject<PremiumHolder>().isPremiumStream.listen((event) {
      setState(() {});
    });
    collapsedStateSub = notifier.collapsedNativeAdsState.listen(
      (event) {
        if (!event) {
          nativeStateSubs?.cancel();
          nativeStateSubs = context
              .read<NativeAdsNotifier>()
              .loadAds(widget.nativeAdId, nativeAdFactory)
              ?.nativeLoaderState
              .listen((event) {
            setState(() {
              if (event.state == DataState.error) {
                widget.onNativeError?.call();
              }
              adLoaderState = event;
            });
          });
        }
      },
    );
  }
}
