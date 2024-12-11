part of '../full_screen_native_loader.dart';

@injectable
class FullscreenNativeNotifier extends BaseChangeNotifier {
  Timer? timer;

  final AdShared adShared;

  FullscreenNativeNotifier(this.adShared);

  late final config = adShared.fullScreenNativeConfig;

  late final _timeCountDown = BehaviorSubject.seeded(config.durationInSeconds);
  ValueStream<int> get timeCountDown => _timeCountDown.stream;

  late final _closeButtonEnabled = BehaviorSubject.seeded(false);
  Stream<bool> get closeButtonEnabled => _closeButtonEnabled.stream;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      _timeCountDown.addSafety(_timeCountDown.value - 1);
      if (_timeCountDown.value < 0) {
        _cancelTimer();
        await Future.delayed(Duration(seconds: 2));
        _closeButtonEnabled.addSafety(true);
      }
    });
  }

  void _cancelTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    _timeCountDown.close();
    _closeButtonEnabled.close();
    _cancelTimer();
    super.dispose();
  }
}
