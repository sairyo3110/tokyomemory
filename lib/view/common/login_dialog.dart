import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';

class LoginAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Change the background color here
      title: Text('この機能を使うには会員登録が必要です。',
          style: TextStyle(color: AppColors.primary)),
      content: Text('設定のログインボタンから会員登録を行ってください。'),
      actions: <Widget>[
        TextButton(
          child: Text('キャンセル', style: TextStyle(color: AppColors.primary)),
          onPressed: () {
            Navigator.of(context).pop(); // ダイアログを閉じる
          },
        ),
      ],
    );
  }
}
