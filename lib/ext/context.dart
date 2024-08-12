import 'dart:async';

import 'package:admob/ad_loader_listener.dart';
import 'package:admob/admob.dart';
import 'package:admob/listener/global_listener.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/data/response.dart';
import 'package:flutter_core/ext/di.dart';

extension ContextExt on BuildContext {
  Future<dynamic> pushScreenWithAds<T>(Route<T> route,
      {bool ignoreAds = false,
      bool isReplacement = false,
      AdLoaderListener? adLoaderListener}) async {
    final adShared = appInject<AdShared>();
    final interWhenBack = adShared.useInterOnBack;
    final completer = Completer<dynamic>();
    if (ignoreAds) {
      try {
        final r = isReplacement
            ? await Navigator.pushReplacement(this, route)
            : await Navigator.push(this, route);
        completer.complete(r);
        if (interWhenBack) {
          GlobalAdListener.onBackPressedIOS?.call(this);
        }
      } catch (e) {
        completer.complete(Response.failed(e));
      }
      adLoaderListener?.onInterPassed?.call();
      return;
    }
    (appInject<InterstitialLoader>()).show(
        adLoaderListener: AdLoaderListener(onAdFailedToLoad: () {
      adLoaderListener?.onAdFailedToLoad?.call();
    }, onInterPassed: () async {
      try {
        final r = isReplacement
            ? await Navigator.pushReplacement(this, route)
            : await Navigator.push(this, route);
        completer.complete(r);
        if (interWhenBack) {
          GlobalAdListener.onBackPressedIOS?.call(this);
        }
      } catch (e) {
        completer.complete(Response.failed(e));
      }
      adLoaderListener?.onInterPassed?.call();
    }, onAdConsume: () {
      adLoaderListener?.onAdConsume?.call();
    }, onAdStartShow: () {
      adLoaderListener?.onAdStartShow?.call();
    }, onAdClosed: () {
      adLoaderListener?.onAdClosed?.call();
    }, onAdFailedToShow: () {
      adLoaderListener?.onAdFailedToShow?.call();
    }));

    return await completer.future;
  }

  popScreenWithAds<T extends Object?>(
      {T? result,
      bool ignoreAds = false,
      AdLoaderListener? adLoaderListener}) async {
    try {
      if (Navigator.canPop(this)) {
        CrashlyticsLogger.logError(
            "pop screen ${widget.runtimeType.toString()}");
        final shared = appInject<AdShared>();
        if (ignoreAds || !shared.useInterOnBack) {
          Navigator.of(this, rootNavigator: true).pop(result);
          adLoaderListener?.onInterPassed?.call();
          return;
        }
        (appInject<InterstitialLoader>()).show(
            adLoaderListener: AdLoaderListener(onAdFailedToLoad: () {
          adLoaderListener?.onAdFailedToLoad?.call();
        }, onInterPassed: () {
          Navigator.of(this, rootNavigator: true).pop(result);
          adLoaderListener?.onInterPassed?.call();
        }, onAdConsume: () {
          adLoaderListener?.onAdConsume?.call();
        }, onAdStartShow: () {
          adLoaderListener?.onAdStartShow?.call();
        }, onAdClosed: () {
          adLoaderListener?.onAdClosed?.call();
        }, onAdFailedToShow: () {
          adLoaderListener?.onAdFailedToShow?.call();
        }));
      }
    } catch (e) {}
  }
}
