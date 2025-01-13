// TODO Implement this library.

import 'package:admob/listener/global_listener.dart';
import 'package:flutter/material.dart';

class AppAds extends StatefulWidget {

  final Widget child;
  const AppAds({super.key, required this.child});

  @override
  State<AppAds> createState() => _AppAdsState();
}

class _AppAdsState extends State<AppAds> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    GlobalAdListener.updateAppState(state);
    super.didChangeAppLifecycleState(state);
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
