library admob;

import 'admob_platform_interface.dart';

export 'interstitial/interstitial_ad.dart';
export 'native/collapsed_native_view.dart';
export 'native/full_screen/full_screen_native_loader.dart';
export 'native/normal_native_view.dart';
export 'presenter/native_ads_presenter.dart';
export 'presenter/premium_cubit.dart';
export 'package:admob/components/app_ads.dart';

class Admob {
  Future<String?> getPlatformVersion() {
    return AdmobPlatform.instance.getPlatformVersion();
  }

  Stream<dynamic> get onRequestInitAdSdk =>
      AdmobPlatform.instance.onRequestInitAdSdk;

  Stream<dynamic> get onConsentDismiss =>
      AdmobPlatform.instance.onConsentDismiss;
}
