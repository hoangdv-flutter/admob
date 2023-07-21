import 'package:flutter_core/ext/di.dart';
import 'package:admob/shared/ads_shared.dart';
import 'package:flutter_core/presenter/base_cubit.dart';
import 'package:rxdart/rxdart.dart';

class PremiumCubit extends BaseCubit {
  PremiumCubit() : super(null);

  late final _appShared = appInject<AdShared>();

  bool get isPremium => _appShared.isPremium;

  ValueStream<bool> get isPremiumStream => _appShared.isPremiumStream;
}
