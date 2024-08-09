import 'package:flutter_test/flutter_test.dart';
import 'package:admob/admob.dart';
import 'package:admob/admob_platform_interface.dart';
import 'package:admob/admob_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAdmobPlatform
    with MockPlatformInterfaceMixin
    implements AdmobPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void applyMethodChannel() {
    // TODO: implement applyMethodChannel
  }

  @override
  Stream get onConsentDismiss => throw UnimplementedError();

  @override
  Stream get onRequestInitAdSdk => throw UnimplementedError();

  @override
  void notifyConsentDismiss() {}
}

void main() {
  final AdmobPlatform initialPlatform = AdmobPlatform.instance;

  test('$MethodChannelAdmob is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAdmob>());
  });

  test('getPlatformVersion', () async {
    Admob admobPlugin = Admob();
    MockAdmobPlatform fakePlatform = MockAdmobPlatform();
    AdmobPlatform.instance = fakePlatform;

    expect(await admobPlugin.getPlatformVersion(), '42');
  });
}
