import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/core.dart';
import 'package:rxdart/rxdart.dart';

import 'admob_platform_interface.dart';

/// An implementation of [AdmobPlatform] that uses method channels.
///
class MethodChannelAdmob extends AdmobPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('admob');

  late final _onRequestInitAdSdk = BehaviorSubject();

  @override
  Stream<dynamic> get onRequestInitAdSdk => _onRequestInitAdSdk.stream;

  late final _onConsentDismiss = BehaviorSubject<bool>();

  @override
  Stream<dynamic> get onConsentDismiss => _onConsentDismiss.stream;

  MethodChannelAdmob() {
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case PluginMethods.onConsentDismiss:
          debugPrint("Ad Consent State onConsentDismiss");
          notifyConsentDismiss();
          break;

        case PluginMethods.onRequestInitAdSdk:
          debugPrint("Ad Consent State onRequestInitAdSdk");
          _onRequestInitAdSdk.addSafety(true);
          break;
      }
    });
    if (Platform.isAndroid) {
      methodChannel.invokeMethod(PluginMethods.showConsentForm);
    }
  }

  @override
  void notifyConsentDismiss() {
    print("notifyConsentDismiss");
    _onConsentDismiss.addSafety(true);
  }

  @override
  void applyMethodChannel() {}

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

class PluginMethods {
  static const onConsentDismiss = "onConsentDismiss";
  static const onRequestInitAdSdk = "onRequestInitAdSdk";
  static const showConsentForm = "showConsentForm";
}
