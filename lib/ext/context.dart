import 'dart:async';

import 'package:admob/ad_loader_listener.dart';
import 'package:admob/admob.dart';
import 'package:admob/listener/global_listener.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/data/response.dart';
import 'package:flutter_core/data/shared/premium_holder.dart';

extension ContextExt on BuildContext {
  Future<dynamic> pushScreenWithAds<T>(
    Route<T> route, {
    required String adsID,
    bool ignoreAds = false,
    bool isReplacement = false,
    AdLoaderListener? adLoaderListener,
  }) async {
    final adShared = appInject<AdShared>();
    final premiumHolder = appInject<PremiumHolder>();
    final interWhenBack = adShared.useInterOnBack;
    final navigator = Navigator.of(this, rootNavigator: true);

    Future<dynamic> pushAction() async {
      try {
        final result = isReplacement
            ? await navigator.pushReplacement(route)
            : await navigator.push(route);

        if (interWhenBack) {
          GlobalAdListener.onBackPressedIOS?.call(this);
        }

        return result;
      } catch (e) {
        return Response.failed(e);
      }
    }

    if (ignoreAds) {
      final result = await pushAction();
      adLoaderListener?.onInterPassed?.call();
      return result;
    }

    if (premiumHolder.isPremium) {
      final result = await pushAction();
      adLoaderListener?.onInterPassed?.call();
      return result;
    }

    if (!adShared.canShowInterstitial) {
      final result = await pushAction();
      adLoaderListener?.onInterPassed?.call();
      return result;
    }

    final configs = adShared.interNativeConfig[adsID];

    if ((configs?.showable == false || configs == null) &&
        adShared.adsPlanConfig == 2) {
      final result = await pushAction();
      adLoaderListener?.onInterPassed?.call();
      return result;
    }

    final completer = Completer<dynamic>();

    if (configs?.nativeFullScreen == false || adShared.adsPlanConfig == 1) {
      (appInject<InterstitialLoader>()).show(
          adsID: adsID,
          context: this,
          adLoaderListener: AdLoaderListener(onAdFailedToLoad: () {
            adLoaderListener?.onAdFailedToLoad?.call();
          }, onInterPassed: () async {
            final result = await pushAction();
            completer.complete(result);
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
    } else {
      final r = await pushScreen(FullScreenNativeScreen.newRoute());

      if (r != null) {
        final result = await pushAction();
        completer.complete(result);
      }
    }

    return await completer.future;
  }

  popScreenWithAds<T extends Object?>(
      {required String adsID,
      T? result,
      bool ignoreAds = false,
      AdLoaderListener? adLoaderListener}) async {
    try {
      bool hasPopped = false;
      final adShared = appInject<AdShared>();
      final premiumHolder = appInject<PremiumHolder>();
      final configs = adShared.interNativeConfig[adsID];

      void safePop() {
        if (hasPopped || !mounted) return;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            final navigator = Navigator.maybeOf(this, rootNavigator: true);

            if (navigator != null && navigator.canPop()) {
              hasPopped = true;
              navigator.pop(result);
            }
          }
        });
      }

      if (Navigator.canPop(this)) {
        CrashlyticsLogger.logError(
            "pop screen ${widget.runtimeType.toString()}");

        final shared = appInject<AdShared>();

        if (ignoreAds || !shared.useInterOnBack) {
          safePop();

          adLoaderListener?.onInterPassed?.call();

          return;
        }

        if ((configs?.showable == false || configs == null) &&
            adShared.adsPlanConfig == 2) {
          safePop();

          adLoaderListener?.onInterPassed?.call();

          return;
        }

        if (premiumHolder.isPremium) {
          safePop();

          adLoaderListener?.onInterPassed?.call();

          return;
        }

        if (!adShared.canShowInterstitial) {
          safePop();

          adLoaderListener?.onInterPassed?.call();

          return;
        }

        if (configs?.nativeFullScreen == false || adShared.adsPlanConfig == 1) {
          (appInject<InterstitialLoader>()).show(
              adsID: adsID,
              context: this,
              adLoaderListener: AdLoaderListener(onAdFailedToLoad: () {
                adLoaderListener?.onAdFailedToLoad?.call();
              }, onInterPassed: () {
                safePop();

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
        } else {
          final r = await pushScreen(FullScreenNativeScreen.newRoute());

          if (r != null) safePop();
        }
      }
    } catch (_) {}
  }
}
