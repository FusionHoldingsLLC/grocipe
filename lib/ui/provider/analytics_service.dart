import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> sendAnalyticsEvent({required String eventName, String? clickEvent}) async {
    final Map<String, Object> parameters = {};

    if (clickEvent != null) {
      parameters['clickEvent'] = clickEvent;
    }

    await _analytics.logEvent(
      name: eventName,
      parameters: parameters.isNotEmpty ? parameters : null,
    );
  }
}
