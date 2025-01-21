import 'package:admob/ext/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/core.dart';

abstract class AdsBaseScreen extends BaseScreen {
  const AdsBaseScreen({super.key});

  @override
  void onBackPressedIOS(BuildContext context) {
    // if (appInject<AdShared>().useInterOnBack) {
    //   GlobalAdListener.onBackPressedIOS?.call(context);
    // }
  }

  @override
  Future<bool> onBackPressed(BuildContext context) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    context.valid?.popScreenWithAds();
    return false;
  }
}

abstract class AdsBaseScreenState<S extends StatefulWidget>
    extends BaseScreenState<S> {
  @override
  Future<bool> onBackPressed(BuildContext context) async {
    context.valid?.popScreenWithAds();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return false;
  }

  @override
  void onBackPressedIOS() {
    // if (appInject<AdShared>().useInterOnBack) {
    //   GlobalAdListener.onBackPressedIOS?.call(context);
    // }
  }
}
