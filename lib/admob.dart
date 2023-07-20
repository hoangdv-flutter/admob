
import 'admob_platform_interface.dart';

class Admob {
  Future<String?> getPlatformVersion() {
    return AdmobPlatform.instance.getPlatformVersion();
  }
}
