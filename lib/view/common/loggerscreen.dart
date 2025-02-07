import 'package:flutter/material.dart';
import 'package:mapapp/service/analytics.dart';

abstract class LoggingScreen extends StatelessWidget {
  final FirebaseLogger logger = FirebaseLogger.instance;

  LoggingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logScreenView();
    return buildScreen(context);
  }

  void logScreenView() {
    logger.logEvent(
      'screen_view',
      parameters: {
        'screen_name': this.runtimeType.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Widget buildScreen(BuildContext context);
}
