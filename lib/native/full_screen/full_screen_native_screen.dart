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
    return ChangeNotifierProvider(
      create: (context) => appInject<FullscreenNativeNotifier>(),
      child: ScreenTemplate(
          child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Positioned.fill(child: AdWidget(ad: context.argument())),
          _CountDownToCloseAds()
        ]),
      )),
    );
  }
}

class _CountDownToCloseAds extends StatefulWidget {
  const _CountDownToCloseAds({super.key});

  @override
  State<_CountDownToCloseAds> createState() => _CountDownToCloseAdsState();
}

class _CountDownToCloseAdsState extends State<_CountDownToCloseAds> {
  late final _notifier = context.read<FullscreenNativeNotifier>();

  StreamSubscription? _countDownSubs;
  StreamSubscription? _closeState;

  var _timeCountDown = 0;

  var _closeButtonState = false;

  @override
  void initState() {
    super.initState();

    _notifier.startTimer();
    _closeState = _notifier.closeButtonEnabled.listen(
      (event) {
        setState(() {
          _closeButtonState = event;
        });
      },
    );

    _countDownSubs = _notifier.timeCountDown.listen(
      (event) {
        setState(() {
          _timeCountDown = event;
        });
      },
    );
  }

  @override
  void dispose() {
    _countDownSubs?.cancel();
    _closeState?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.all(2.p),
      child: _closeButtonState
          ? IconButton(
              onPressed: () {
                context.popScreen();
              },
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.black.withAlpha(70))),
              iconSize: 5.p,
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ))
          : _timeCountDown > -1
              ? Container(
                  padding: EdgeInsets.all(2.p),
                  margin: EdgeInsets.all(1.p),
                  decoration: BoxDecoration(
                      color: Colors.black.withAlpha(70),
                      shape: BoxShape.circle),
                  child: Text(
                    "$_timeCountDown",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(),
    );
  }
}
