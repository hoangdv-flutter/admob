import 'package:admob/admob_method_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rxdart/rxdart.dart';

class GlobalAdListener {
  static OnPaidEventCallback? onPaidEventCallback;

  static OnBackPressedIOS? onBackPressedIOS;

  GlobalAdListener._();

  static late final _appState = BehaviorSubject<AppLifecycleState>();

  static Stream<AppLifecycleState> get appState => _appState.stream;

  static void updateAppState(AppLifecycleState state) => _appState.addSafety(state);
}

typedef OnBackPressedIOS = Function(BuildContext context);
