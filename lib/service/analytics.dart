import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseLogger {
  static final FirebaseLogger _instance = FirebaseLogger._internal();
  late FirebaseAnalytics analytics;
  late FirebaseAnalyticsObserver observer;

  factory FirebaseLogger() {
    return _instance;
  }

  FirebaseLogger._internal() {
    analytics = FirebaseAnalytics.instance;
    observer = FirebaseAnalyticsObserver(analytics: analytics);
  }

  static FirebaseLogger get instance => _instance;

  Future<void> logAppOpen() async {
    await analytics.logAppOpen();
  }

  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    await analytics.logEvent(name: name, parameters: parameters);
  }
}
