import 'dart:async';

import 'package:admob/ad_loader_listener.dart';
import 'package:admob/interstitial/interstititial_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/data/response.dart';
import 'package:flutter_core/ext/di.dart';
import 'package:flutter_core/util/crash_log.dart';

extension ContextExt on BuildContext {
  Future<dynamic> pushScreenWithAds<T>(Route<T> route,
      {bool ignoreAds = false, bool isReplacement = false}) async {
    final completer = Completer<dynamic>();
    if (ignoreAds) {
      try {
        final r = isReplacement
            ? await Navigator.pushReplacement(this, route)
            : await Navigator.push(this, route);
        completer.complete(r);
      } catch (e) {
        completer.complete(Response.failed(e));
      }
      return;
    }
    (appInject<InterstitialLoader>()).show(adLoaderListener: AdLoaderListener(
      onInterPassed: () async {
        try {
          final r = isReplacement
              ? await Navigator.pushReplacement(this, route)
              : await Navigator.push(this, route);
          completer.complete(r);
        } catch (e) {
          completer.complete(Response.failed(e));
        }
      },
    ));
    return await completer.future;
  }

  popScreenWithAds<T extends Object?>(
      {T? result, bool ignoreAds = false, Function()? onAdsDismiss}) async {
    try {
      if (Navigator.canPop(this)) {
        CrashlyticsLogger.logError(
            "pop screen ${widget.runtimeType.toString()}");
        if (ignoreAds) {
          onAdsDismiss?.call();
          Navigator.of(this, rootNavigator: true).pop(result);
          return;
        }
        (appInject<InterstitialLoader>()).show(
            adLoaderListener: AdLoaderListener(onInterPassed: () {
          onAdsDismiss?.call();
          Navigator.of(this, rootNavigator: true).pop(result);
        }));
      }
    } catch (e) {}
  }
}
