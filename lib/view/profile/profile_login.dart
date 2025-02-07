import 'package:flutter/material.dart';
import 'package:mapapp/utils.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/profile/profile_setting.dart';

class ProfileLogin extends StatelessWidget {
  void _onSettingsButtonPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileSetting()), // 設定画面に遷移
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showSettingsButton: true, // 設定ボタンを表示
        onSettingsButtonPressed: () =>
            _onSettingsButtonPressed(context), // 設定ボタンが押された時のコールバック
      ),
      body: BaseScreen(
        body: Container(
          padding: EdgeInsets.all(40),
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              Image.asset('images/logintec.png', width: 500),
              SizedBox(height: 20), // テキストとボタンの間にスペースを追加
              ElevatedButton(
                child: Text('ログイン'),
                onPressed: () => showOverlay(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
