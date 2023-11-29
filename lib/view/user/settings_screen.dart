import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  /// 表示用のアプリバージョンテキストを返却します。
  Future<String> getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var text = 'バージョン:${packageInfo.version}(${packageInfo.buildNumber})';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 16), // 余白を追加してボタンとテキストを少し離す
                Text(
                  "アプリについて",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('公式サイト'),
            onTap: () async {
              // 遷移したいURL
              const url = 'https://sora-tokyo-dateplan.com/';

              // URLを開くことができるかどうかを確認
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            title: Text('利用規約'),
            onTap: () async {
              // 遷移したいURL
              const url = 'https://enplace-tokyo.com/kiyaku/';

              // URLを開くことができるかどうかを確認
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            title: Text('プライバシーポリシー'),
            onTap: () async {
              // 遷移したいURL
              const url = 'https://enplace-tokyo.com/privacy/';

              // URLを開くことができるかどうかを確認
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          FutureBuilder<String>(
            future: getVersionInfo(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return ListTile(
                title: Text(
                  snapshot.hasData ? snapshot.data : '',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
