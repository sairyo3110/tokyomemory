import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/user/user.dart';
import 'package:mapapp/businesslogic/user/user_servis.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/common/bottomnavigation.dart';
import 'package:mapapp/view/common/use/Introslider.dart';
import 'package:mapapp/view/profile/widget/text.dart';
import 'package:mapapp/view/search/spot/widget/list/line.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileSetting extends StatelessWidget {
  final UserService userService = UserService();

  Future<void> _signOut() async {
    print('signing out');
    try {
      await Amplify.Auth.signOut(
        options: const SignOutOptions(globalSignOut: true),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    print('deleting account');
    try {
      await userService.deleteUser();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainBottomNavigation()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Error deleting account: $e');
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('アカウント削除確認'),
          content: Text('本当にアカウントを削除しますか？この操作は元に戻せません。'),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('削除'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// 表示用のアプリバージョンテキストを返却します。
  Future<String> getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var text = 'バージョン:${packageInfo.version}(${packageInfo.buildNumber})';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).userId ?? '';
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showBackButton: true,
      ),
      body: BaseScreen(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileTapTextWidget(
                      text: '使い方の表示',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  IntroSliderScreen()), // 設定画面に遷移
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileTapTextWidget(
                      text: '公式サイト',
                      onTap: () =>
                          _launchURL('https://sora-tokyo-dateplan.com/'),
                    ),
                    SpotLine(),
                    ProfileTapTextWidget(
                      text: '利用規約',
                      onTap: () =>
                          _launchURL('https://enplace-tokyo.com/kiyaku/'),
                    ),
                    SpotLine(),
                    ProfileTapTextWidget(
                      text: 'プライバシーポリシー',
                      onTap: () =>
                          _launchURL('https://enplace-tokyo.com/privacy/'),
                    ),
                  ],
                ),
              ),
              if (userId.isNotEmpty) SizedBox(height: 50),
              if (userId.isNotEmpty)
                Container(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileTapTextWidget(
                        text: 'ログアウト',
                        onTap: () {
                          _signOut().then((_) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MainBottomNavigation()),
                              (Route<dynamic> route) => false,
                            );
                          });
                        },
                      ),
                      SpotLine(),
                      ProfileTapTextWidget(
                        text: 'アカウント削除',
                        onTap: () {
                          _showDeleteConfirmationDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 50),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String>(
                      future: getVersionInfo(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return ProfileTapTextWidget(
                          text: snapshot.data ?? '',
                          onTap: () {},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
