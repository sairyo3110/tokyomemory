import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mapapp/test/view/login_main.dart';
import 'package:mapapp/view/common/bottomnavigation.dart';
import 'package:share/share.dart';

void shareContent({
  required BuildContext context,
  required String placeId,
  required String name,
}) {
  final String deepLinkUrl = 'mapapp://spot/$placeId';
  const String AndroidLinkUrl =
      'https://play.google.com/store/apps/details?id=tokyomemory.mapapp0918&pli=1';
  final String IOSLinkUrl =
      'https://apps.apple.com/jp/app/tokyo-memory/id6466747873';

  String shareMessage = 'いい感じのお店見つけた！\n\n$name\n\n▼ここから見てみて！\n$deepLinkUrl';

  if (!kIsWeb) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      shareMessage += '\n\nアプリをダウンロードしていない場合はここから▼\n$AndroidLinkUrl';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      shareMessage += '\n\nアプリをダウンロードしていない場合はここから▼\n$IOSLinkUrl';
    }
  }

  Share.share(shareMessage);
}

void sharePlan({
  required BuildContext context,
  required String planId,
  required String name,
}) {
  final String deepLinkUrl = 'mapapp://plan/$planId';
  const String AndroidLinkUrl =
      'https://play.google.com/store/apps/details?id=tokyomemory.mapapp0918&pli=1';
  final String IOSLinkUrl =
      'https://apps.apple.com/jp/app/tokyo-memory/id6466747873';

  String shareText =
      'このデートプランで今度デートしてみない？\n\n$name}\n\n▼ここから見てみて！\n$deepLinkUrl';

  if (!kIsWeb) {
    if (Platform.isAndroid) {
      shareText += '\n\nアプリをダウンロードしていない場合はここから▼\n$AndroidLinkUrl';
    } else if (Platform.isIOS) {
      shareText += '\n\nアプリをダウンロードしていない場合はここから▼\n$IOSLinkUrl';
    }
  }

  Share.share(shareText);
}

void updateTime(State state, Function setTime) {
  final now = DateTime.now();
  // ignore: invalid_use_of_protected_member
  state.setState(() {
    setTime(now.toString());
  });
}

String formatTime(String time) {
  if (time.isEmpty) return '';
  try {
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return time;
  } catch (e) {
    return '';
  }
}

void showOverlay(BuildContext context) {
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute(
      builder: (context) => Authentication(),
    ),
  );
}

void showOverlay2(BuildContext context) {
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute(
      builder: (context) => MainBottomNavigation(),
    ),
  );
}
