import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'admob_platform_interface.dart';

/// An implementation of [AdmobPlatform] that uses method channels.
class MethodChannelAdmob extends AdmobPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('admob');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
