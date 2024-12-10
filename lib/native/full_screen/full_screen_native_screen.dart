part of 'full_screen_native_loader.dart';

class FullScreenNativeScreen extends BaseScreen {
  static Route newRoute(NativeAd nativeAd) => RouterCreator.createRouter(
      pageBuilder: (context, animation, scondaryAnimation) =>
          FullScreenNativeScreen._(),
      settings: RouteSettings(arguments: nativeAd),
      reverserDuration: Duration(milliseconds: 0),
      transitionDuration: Duration(milliseconds: 0));

  const FullScreenNativeScreen._({super.key});

  @override
  Widget onBuild(BuildContext context) {
    return ScreenTemplate(
        child: Scaffold(
      body: AdWidget(ad: context.argument()),
    ));
  }
}
