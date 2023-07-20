import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'admob_method_channel.dart';

abstract class AdmobPlatform extends PlatformInterface {
  /// Constructs a AdmobPlatform.
  AdmobPlatform() : super(token: _token);

  static final Object _token = Object();

  static AdmobPlatform _instance = MethodChannelAdmob();

  /// The default instance of [AdmobPlatform] to use.
  ///
  /// Defaults to [MethodChannelAdmob].
  static AdmobPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AdmobPlatform] when
  /// they register themselves.
  static set instance(AdmobPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
