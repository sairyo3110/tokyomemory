import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/view/user/settings_screen.dart';
import 'package:mapapp/view/user/user_info_screen.dart';
import 'package:share/share.dart';
import 'dart:io' show Platform;

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String? username;
  bool isAndroid = Platform.isAndroid;
  bool isIOS = Platform.isIOS;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      setState(() {
        username = authUser.username;
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut(
        options: const SignOutOptions(globalSignOut: true),
      );
      Navigator.of(context).pop(); // Close the modal bottom sheet
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void _sharePage() {
    final String AndroidLinkUrl =
        'https://play.google.com/store/apps/details?id=tokyomemory.mapapp0918&pli=1';
    final String IOSLinkUrl =
        'https://apps.apple.com/jp/app/tokyo-memory/id6466747873';
    if (isAndroid) {
      Share.share(
          '外さないデートをすぐに見つけられる！\n\n地名や気分からデートプランやお店を探せる『Tokyo Memory』\n\n▼ここから無料ダウンロード！\n$AndroidLinkUrl ');
    }
    if (isIOS) {
      Share.share(
          '外さないデートをすぐに見つけられる！\n\n地名や気分からデートプランやお店を探せる『Tokyo Memory』\n\n▼ここから無料ダウンロード！\n$IOSLinkUrl ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
            ),
          ),
          Center(
            child:
                Text('${username ?? "ユーザー名"}', style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text('プロフィール編集'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileSettingsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('アプリについて'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('ログアウト'),
            onTap: _signOut,
          ),
          ListTile(
            title: Text('アプリをオススメする！'),
            onTap: _sharePage,
          ),
        ],
      ),
    );
  }
}
