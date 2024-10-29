import 'package:flutter_core/core.dart';
import 'package:flutter_core/data/shared/premium_holder.dart';
import 'package:rxdart/rxdart.dart';

class PremiumCubit extends BaseCubit {
  PremiumCubit() : super(null);

  late final _premiumHolder = appInject<PremiumHolder>();

  bool get isPremium => _premiumHolder.isPremium;

  ValueStream<bool> get isPremiumStream => _premiumHolder.isPremiumStream;
}
