import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstPage extends ConsumerWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("サンプルアプリ画面"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              // Firebaseにユーザーがログインしているかを監視する
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                // データがnullならログアウト状態
                return snapshot.data == null
                    ? TextButton(
                        child: const Text(
                          "LINEログイン",
                          style: TextStyle(fontSize: 50),
                        ),
                        onPressed: () async {
                          try {
                            // LINEにログインしてアクセストークンを取得する
                            final lineData = await LineSDK.instance.login();
                            // アクセストークンをcloud functionsへ送信して、Firebase Authenticationのカスタムトークンを発行してもらう
                            final jsonData = await FirebaseFunctions.instance
                                .httpsCallable('register')
                                .call(
                              {
                                'token': lineData.accessToken.value,
                              },
                            );
                            // Firebase Authenticationのカスタムトークンを取得
                            final customToken = jsonData.data['customToken'];
                            // カスタムトークンを使用してAuthenticationに登録する
                            await FirebaseAuth.instance
                                .signInWithCustomToken(customToken);
                          } on PlatformException catch (e) {
                            print(e);
                          }
                        },
                      )
                    : TextButton(
                        child: const Text(
                          "ログアウト",
                          style: TextStyle(fontSize: 50),
                        ),
                        onPressed: () async {
                          // ログアウト処理
                          await LineSDK.instance.logout();
                          await FirebaseAuth.instance.signOut();
                        },
                      );
              }),
        ],
      )),
    );
  }
}
