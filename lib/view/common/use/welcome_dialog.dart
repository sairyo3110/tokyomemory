import 'package:flutter/material.dart';
import 'package:mapapp/view/common/use/Introslider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeDialog {
  static Future<void> showWelcomeMessageIfNeeded(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownWelcomeMessage =
        prefs.getBool('hasShownWelcomeMessage') ?? false;

    if (!hasShownWelcomeMessage) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Tokyo Memoryへようこそ！"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Image.asset('images/Holiday_Tokyo.png'),
                  SizedBox(height: 40),
                  Text('ダウンロードありがとうございます！'),
                  SizedBox(height: 20),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('使い方を見る'),
                onPressed: () {
                  print('使い方を見る');
                  Navigator.of(context).pop(); // ダイアログを閉じる
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IntroSliderScreen(),
                    ),
                  ); // 設定画面に遷移
                },
              ),
              TextButton(
                child: Text('閉じる'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      await prefs.setBool('hasShownWelcomeMessage', true);
    }
  }
}
