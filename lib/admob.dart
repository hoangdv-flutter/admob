library admob;

import 'admob_platform_interface.dart';

export 'interstitial/interstitial_ad.dart';
export 'native/collapsed_native_view.dart';
export 'native/normal_native_view.dart';
export 'presenter/native_ads_presenter.dart';
export 'presenter/premium_cubit.dart';

class Admob {
  Future<String?> getPlatformVersion() {
    return AdmobPlatform.instance.getPlatformVersion();
  }

  Stream<dynamic> get onRequestInitAdSdk =>
      AdmobPlatform.instance.onRequestInitAdSdk;

  Stream<dynamic> get onConsentDismiss =>
      AdmobPlatform.instance.onConsentDismiss;
}
