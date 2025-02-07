import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/view/common/bottomnavigation.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    Key? key,
    required this.state,
    required this.body,
    this.footer,
    this.additionalTextWidget,
  }) : super(key: key);

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;
  final Widget? additionalTextWidget;

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Padding(padding: EdgeInsets.only(top: 32)),
              Image.asset('images/Holiday_Tokyo.png'),
              const SizedBox(height: 20),
              if (widget.additionalTextWidget != null)
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0), // bottom spacing added
                  child: widget.additionalTextWidget!,
                ),
              if (widget.state.currentStep == AuthenticatorStep.signIn)
                CheckboxListTile(
                  title: const Text("利用規約とプライバシーポリシーに同意する"),
                  value: _termsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _termsAccepted = value ?? false;
                    });
                  },
                ),
              if (_termsAccepted ||
                  widget.state.currentStep != AuthenticatorStep.signIn)
                widget.body,
              TextButton(
                child: Text('ログインせずに使う'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MainBottomNavigation(),
                  ));
                },
              ),
              SizedBox(height: 20),
              RichText(
                // <--- ここを変更: additionalTextWidge,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0, // 例: テキストのサイズを変更
                    color: Colors.black, // 例: テキストの色を赤に変更
                  ),
                  children: [
                    TextSpan(text: "※赤く英文でエラーメッセージが表示された方は"),
                    TextSpan(
                        text: "こちら",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // 遷移したいURL
                            const url =
                                'https://docs.google.com/document/d/1wkDuukmF051jZ10rfEb_CjrYadRKFFzJcYn5bog9cVs/edit?usp=sharing';

                            // URLを開くことができるかどうかを確認
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: widget.footer != null ? [widget.footer!] : null,
    );
  }
}
