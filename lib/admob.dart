library admob;
export 'interstitial/interstitial_ad.dart';

import 'admob_platform_interface.dart';

class Admob {
  Future<String?> getPlatformVersion() {
    return AdmobPlatform.instance.getPlatformVersion();
  }

  Stream<dynamic> get onRequestInitAdSdk =>
      AdmobPlatform.instance.onRequestInitAdSdk;

  Stream<dynamic> get onConsentDismiss =>
      AdmobPlatform.instance.onConsentDismiss;
}
