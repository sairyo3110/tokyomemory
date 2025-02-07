import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mapapp/service/analytics.dart';

class LoggableImage extends StatelessWidget {
  final String imagePath;
  final String logEventName;
  final Map<String, dynamic> logParameters;
  final String link; // リンクを追加

  LoggableImage({
    required this.imagePath,
    required this.logEventName,
    required this.logParameters,
    required this.link, // リンクを初期化
  });

  Future<void> _launchURL(BuildContext context) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(imagePath),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.7) {
          FirebaseLogger.instance.logEvent(
            logEventName,
            parameters: logParameters,
          );
        }
      },
      child: GestureDetector(
        onTap: () => _launchURL(context), // タップ時にリンクを開く
        child: Image.asset(imagePath),
      ),
    );
  }
}
