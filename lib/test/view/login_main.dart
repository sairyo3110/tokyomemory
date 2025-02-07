import 'package:flutter/material.dart';
import 'package:mapapp/test/view/login.dart';
import 'package:mapapp/test/view/register.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/common/bottomnavigation.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showRegister = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'ログイン',
        ),
        body: BaseScreen(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      if (showRegister) RegisterPage() else LoginScreenPage(),
                      TextButton(
                        child: Text('ログインせずに使う'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MainBottomNavigation(),
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Divider(
                      color: Colors.grey,
                      thickness: 1.5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showRegister)
                          Text('すでにアカウントを持っている場合')
                        else
                          Text('まだアカウントを持っていない場合'),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showRegister = !showRegister;
                            });
                          },
                          child: Text(showRegister ? "ログイン" : "新規登録"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
