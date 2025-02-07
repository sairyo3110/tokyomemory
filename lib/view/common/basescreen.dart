import 'package:flutter/material.dart';
import 'package:mapapp/service/analytics.dart'; // FirebaseLoggerのインポート

class BaseScreen extends StatelessWidget {
  final FirebaseLogger logger = FirebaseLogger.instance;
  final Widget? body;
  final bool showBackButton;

  BaseScreen({
    Key? key,
    this.body,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logScreenView();
    return Scaffold(
      body: body ?? Container(),
      backgroundColor: Colors.white,
    );
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
}
