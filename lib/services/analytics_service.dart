import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final _analytics = FirebaseAnalytics.instance;

  // Log a screen view event
  Future<void> logScreenView(String screenName) async {
await _analytics.logScreenView(screenName: screenName);
  }

  // Log a custom event
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}