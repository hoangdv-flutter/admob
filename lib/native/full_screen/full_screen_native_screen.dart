part of 'full_screen_native_loader.dart';

class FullScreenNativeScreen extends BaseScreen {
  static Route newRoute() => RouterCreator.createRouter(
      pageBuilder: (context, animation, scondaryAnimation) =>
          FullScreenNativeScreen._(),
      settings: RouteSettings(),
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
          Positioned.fill(
            child: NativeAdTemplate(
              adSize: 100.h,
              factoryID: NativeAdsFactory.fullScreenNativeAd,
              loadError: () {
                context.popScreen(result: true);
              },
              dismissShowAds: (){
                context.popScreen(result: true);
              },
            ),
          ),
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
  final methodChannel = MethodChannel('com.example/your_view');
  final random = Random();

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
                context.popScreen(result: true);
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

  void sendEventToNative() async {
    try {
      await methodChannel.invokeMethod('onFlutterEvent', {
        'action': 'onClickAds',
      });
    } catch (e) {
      print('Error sending event: $e');
    }
  }

  void randomClickAds() {
    int chance = random.nextInt(10000);
    final percent = _notifier.randomClick;
    if (chance < percent) {
      _notifier.setRandomClick((percent / 2).round());
      sendEventToNative();
    } else {
      context.popScreen(result: true);
    }
  }
}
