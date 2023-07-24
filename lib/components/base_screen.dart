import 'package:admob/ext/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/base_screen.dart';
import 'package:flutter_core/ext/context.dart';

abstract class AdsBaseScreen extends BaseScreen {
  const AdsBaseScreen({super.key});

  @override
  Future<bool> onBackPressed(BuildContext context) async {
    context.valid?.popScreenWithAds();
    return false;
  }
}

abstract class AdsBaseScreenState<S extends StatefulWidget>
    extends BaseScreenState<S> {
  @override
  Future<bool> onBackPressed(BuildContext context) async {
    context.valid?.popScreenWithAds();
    return false;
  }
}
