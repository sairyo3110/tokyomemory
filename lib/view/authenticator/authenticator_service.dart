import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/amplifyconfiguration.dart';
import 'package:mapapp/importer.dart';
import 'package:mapapp/resolver.dart';
import 'package:mapapp/view/authenticator/custom_scaffold.dart';
import 'package:mapapp/view/navigation/main_bottom_navigation.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';

class AuthenticationManager extends StatefulWidget {
  const AuthenticationManager({Key? key}) : super(key: key);

  @override
  _AuthenticationManagerState createState() => _AuthenticationManagerState();
}

class _AuthenticationManagerState extends State<AuthenticationManager> {
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
    } on AmplifyException catch (e) {
      print('Could not configure Amplify: ${e.message}');
      print('Detailed Error: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      stringResolver: stringResolver,
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        print('Current Authenticator Step: ${state.currentStep}');
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
              ),
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
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF444440),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFFF6E6DC)),
          ),
        ),
        home: MainBottomNavigation(),
      ),
    );
  }
}
