import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/service/amplifyconfiguration.dart';
import 'package:mapapp/view/common/bottomnavigation.dart';
import 'package:mapapp/view/profile/login/custom_scaffold.dart';
import 'package:mapapp/view/profile/login/resolver.dart';
import 'package:url_launcher/url_launcher.dart';

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
    } on Exception catch (e) {
      print('Error configuring Amplify: $e');
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
            );
          default:
        }
      },
      child: MaterialApp(
        builder: Authenticator.builder(),
        title: 'MapApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            background: AppColors.primary,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
          ),
        ),
        home: MainBottomNavigation(),
      ),
    );
  }
}
