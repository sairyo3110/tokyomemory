import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/test/view/home.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage();

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String registerUserEmail = "";
  String registerUserPassword = "";
  String DebugText = "";
  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: [
              TextSpan(text: "アカウントを新規作成する場合は、"),
              TextSpan(
                  text: "利用規約",
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url = 'https://enplace-tokyo.com/kiyaku/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }),
              TextSpan(text: "と"),
              TextSpan(
                text: "プライバシーポリシー",
                style: TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    const url = 'https://enplace-tokyo.com/privacy/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
              ),
              TextSpan(text: "に同意するものとします。"),
            ],
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: agreedToTerms,
              onChanged: (bool? value) {
                setState(() {
                  agreedToTerms = value ?? false;
                });
              },
            ),
            Text(
              "利用規約とプライバシーポリシーに同意する",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        if (agreedToTerms) ...[
          TextFormField(
            decoration: InputDecoration(labelText: "メールアドレスを入力"),
            onChanged: (String value) {
              setState(() {
                registerUserEmail = value;
              });
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "6桁以上のパスワードを入力"),
            obscureText: true,
            onChanged: (String value) {
              setState(() {
                registerUserPassword = value;
              });
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              try {
                final FirebaseAuth auth = FirebaseAuth.instance;
                final UserCredential result =
                    await auth.createUserWithEmailAndPassword(
                  email: registerUserEmail,
                  password: registerUserPassword,
                );
                final User user = result.user!;
                setState(() {
                  DebugText = "Register OK：${user.email}";
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(user: user)),
                );
              } catch (e) {
                setState(() {
                  DebugText = "Register Fail：${e.toString()}";
                });
              }
            },
            child: Text("新規登録"),
          ),
          const SizedBox(height: 8),
          Text(DebugText),
        ],
      ],
    );
  }
}
