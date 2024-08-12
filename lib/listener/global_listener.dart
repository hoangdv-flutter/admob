import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GlobalAdListener {
  static OnPaidEventCallback? onPaidEventCallback;

  static OnBackPressedIOS? onBackPressedIOS;
}

typedef OnBackPressedIOS = Function(BuildContext context);
