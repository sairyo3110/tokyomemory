import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapapp/repository/appver_controller.dart';
import 'package:mapapp/test/places_provider.dart';
import 'package:mapapp/view/navigation/main_bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'amplifyconfiguration.dart';
import 'resolver.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppVersionController()),
        ChangeNotifierProvider(create: (context) => PlacesProvider(context)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      print('Successfully configured');
    } on AmplifyException {}
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      stringResolver: stringResolver,
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signUp:
            return CustomScaffold(
              state: state,
              body: SignInForm(),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('新規アカウント登録はこちらから'),
                  TextButton(
                    onPressed: () => state.changeStep(AuthenticatorStep.signIn),
                    child: const Text('新規登録'),
                  ),
                ],
              ), // <-- この行を追加
            );
          case AuthenticatorStep.signIn:
            return CustomScaffold(
              state: state,
              body: SignUpForm.custom(
                fields: [
                  SignUpFormField.username(),
                  SignUpFormField.email(required: true),
                  SignUpFormField.password(),
                  SignUpFormField.passwordConfirmation(),
                ],
              ),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('すでにアカウントを持っている場合'),
                  TextButton(
                    onPressed: () => state.changeStep(AuthenticatorStep.signUp),
                    child: const Text('ログイン'),
                  ),
                ],
              ),
              additionalTextWidget: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0, // 例: テキストのサイズを変更
                    color: Colors.black, // 例: テキストの色を赤に変更
                  ),
                  children: [
                    TextSpan(text: "アカウントを新規作成する場合は、"),
                    TextSpan(
                        text: "利用規約",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // 遷移したいURL
                            const url = 'https://enplace-tokyo.com/kiyaku/';

                            // URLを開くことができるかどうかを確認
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
                    TextSpan(text: "に同意するものとします。"),
                  ],
                ),
              ),
            );
          default:
            return null;
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: Authenticator.builder(),
        theme: ThemeData(
          brightness: Brightness.dark, // アプリ全体の基本的な色を暗いテーマに設定
          scaffoldBackgroundColor: Color(0xFF444440), // 背景色を #444440 に設定
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFFF6E6DC)),
          ),
        ),
        home: MainBottomNavigation(),
      ),
    );
  }
}

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
  bool _introShown = false;

  @override
  Widget build(BuildContext context) {
    if (!_introShown) {
      return IntroSliderScreen(
        onButtonPressed: () {
          // 新しいコールバックを受け取る
          setState(() {
            _introShown = true;
          });
        },
      );
    }
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
                            const url = 'https://enplace-tokyo.com/kiyaku/';

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

class IntroSliderScreen extends StatefulWidget {
  final VoidCallback onButtonPressed;

  IntroSliderScreen({required this.onButtonPressed});
  @override
  _IntroSliderScreenState createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 4; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 16.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // コンテナの幅を最大に設定
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 要素を上部から配置
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.85, // 画面の高さの70%を使用
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: <Widget>[
                _buildSlide("images/int1.png"),
                _buildSlide("images/int2.png"),
                _buildSlide("images/int3.png"),
                _buildSlide("images/int4.png"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(),
          ),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildSlide(String imagePath) {
    return Column(
      children: <Widget>[
        Image.asset(imagePath),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          child: Text(
            '使い始める',
            style: TextStyle(fontSize: 20), // テキストのサイズを大きくする
          ),
          onPressed: () {
            widget.onButtonPressed(); // コールバックを呼び出す
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black45, // ボタンの背景色
            onPrimary: Colors.white, // テキストの色
            padding:
                EdgeInsets.symmetric(horizontal: 32, vertical: 16), // パディングを追加
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // 角を丸くする
            ),
          ),
        ),
      ],
    );
  }
}
