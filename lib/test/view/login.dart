import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/test/view/custam_bottan.dart';
import 'package:mapapp/test/view/home.dart';
import 'package:mapapp/utils.dart';

class LoginScreenPage extends StatefulWidget {
  LoginScreenPage();

  @override
  _LoginScreenPageState createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  String loginUserEmail = "";
  String loginUserPassword = "";
  String DebugText = "";
  bool showLoginForm = false;

  Future<bool> signInWithGoogle() async {
    try {
      UserCredential? user = await authenticateWithGoogle();
      return user != null;
    } catch (e) {
      return false;
    }
  }

  Future<UserCredential?> authenticateWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      return userCredential;
    }
    return null;
  }

  Future<void> onGoogleSignIn() async {
    try {
      final result = await signInWithGoogle();
      if (result) {
        setState(() {
          DebugText = "Google Sign-In Successful";
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(user: FirebaseAuth.instance.currentUser)),
        );
      }
    } catch (e) {
      setState(() {
        DebugText = "Google Sign-In Failed：${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        CustomButton(
          label: "Googleでログイン",
          color: AppColors.onPrimary,
          textColor: Colors.black,
          onPressed: onGoogleSignIn,
          imagePath: 'images/googleicon.png',
        ),
        const SizedBox(height: 20),
        CustomButton(
          label: "LINEでログイン",
          color: AppColors.onPrimary,
          textColor: Colors.black,
          imagePath: 'images/linelogo.png',
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
              await FirebaseAuth.instance.signInWithCustomToken(customToken);
            } on PlatformException catch (e) {
              print(e);
            }
          },
        ),
        const SizedBox(height: 20),
        CustomButton(
          label: "メールアドレスでログイン",
          color: AppColors.onPrimary,
          textColor: Colors.black,
          onPressed: () {
            setState(() {
              showLoginForm = true;
            });
          },
        ),
        if (showLoginForm) ...[
          TextFormField(
            decoration: InputDecoration(labelText: "メールアドレスを入力"),
            onChanged: (String value) {
              setState(() {
                loginUserEmail = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "パスワードを入力"),
            obscureText: true,
            onChanged: (String value) {
              setState(() {
                loginUserPassword = value;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                final FirebaseAuth auth = FirebaseAuth.instance;
                final UserCredential result =
                    await auth.signInWithEmailAndPassword(
                  email: loginUserEmail,
                  password: loginUserPassword,
                );
                final User user = result.user!;
                setState(() {
                  DebugText = "Succeeded to Login：${user.email}";
                });
                showOverlay2(context);
              } catch (e) {
                setState(() {
                  DebugText = "Failed to Login：${e.toString()}";
                });
              }
            },
            child: Text("ログイン"),
          ),
        ],
        const SizedBox(height: 20),
        Text(DebugText),
      ],
    ));
  }
}
