import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@singleton
class FirebaseAnalyticsService {

  final _remote = FirebaseAnalytics.instance;

  Future<void> logEventParameter(String name, String parameter, String value) async {
    try {
      await _remote.logEvent(name: name, parameters: {parameter: value});
    } catch (_) {}
  }
}