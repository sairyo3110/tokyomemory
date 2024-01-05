import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/component/dialog/user_ivitesincode_dialog.dart';
import 'package:mapapp/model/Invitecode.dart';
import 'package:mapapp/repository/ivaite_controller.dart';
import 'package:mapapp/model/rerated_model.dart';
import 'package:mapapp/view/authenticator/authenticator_service.dart';
import 'package:mapapp/view/user/settings_screen.dart';
import 'package:mapapp/view/user/user_info_screen.dart';
import 'dart:io' show Platform;

class SettingMainScreen extends StatefulWidget {
  @override
  _SettingMainScreenState createState() => _SettingMainScreenState();
}

class _SettingMainScreenState extends State<SettingMainScreen> {
  String? username;
  bool isAndroid = Platform.isAndroid;
  bool isIOS = Platform.isIOS;
  bool isLoading = false;

  String? userid;
  String? inviteCode;
  List<InviteCode> inviteCodes = []; // 招待コードのリスト
  List<UsedInviteCode> usedInviteCodes = []; // 使用済み招待コードのリスト

  List<dynamic> favoriteSpots = []; // お気に入りのスポット情報を保持するリスト
  List<PlaceDetail> favoritePlaces = []; // お気に入りのスポットの詳細情報リスト

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadUsername();
    _loadUserid();
    _fetchInviteCodes();
    _fetchUsedInviteCodes();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      if (offset > 20.0) {
      } else {}
    });
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

  Future<void> _loadUserid() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      setState(() {
        userid = authUser.userId;
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<String?> getCurrentUserId() async {
    try {
      var currentUser = await Amplify.Auth.getCurrentUser();
      return currentUser.userId;
    } on AuthException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _createInviteCode() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? userId = await getCurrentUserId();
      var response = await createInviteCode(userId ?? '');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          inviteCode = data['code'];
          print(userId);
        });
      } else {
        print('Error creating invite code: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 招待コードを取得する関数
  Future<void> _fetchInviteCodes() async {
    setState(() {
      isLoading = true;
    });

    try {
      var fetchedInviteCodes = await fetchInviteCodes();
      setState(() {
        inviteCodes = fetchedInviteCodes;
      });
    } catch (e) {
      print('Error fetching invite codes: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 使用済み招待コードを取得する関数
  Future<void> _fetchUsedInviteCodes() async {
    setState(() {
      isLoading = true;
    });

    try {
      var fetchedUsedInviteCodes = await fetchUsedInviteCodes();
      setState(() {
        usedInviteCodes = fetchedUsedInviteCodes;
      });
    } catch (e) {
      print('Error fetching used invite codes: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildInviteCodeTile() {
    return FutureBuilder<String?>(
      future: getCurrentUserId(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('エラーが発生しました');
        } else {
          String? userid = snapshot.data;
          if (!inviteCodes.any((code) => code.userId == userid) &&
              !usedInviteCodes.any((code) => code.userId == userid)) {
            return ListTile(
              title: Text('招待コードを入力する！'),
              onTap: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    UserIvitateIncodeDialog(parentContext: context),
              ),
              trailing: isLoading ? CircularProgressIndicator() : null,
            );
          } else {
            return ListTile(
              title: Text('招待コード入力済み'),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(8.0), // 余白を追加
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.0), // 上に10.0の余白を追加
              Text(
                'Setting',
                style: TextStyle(
                  color: Color(0xFFF6E6DC),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        elevation: 0, // 影を消す
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('アプリについて'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          if (userid != null)
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
            title: Text(userid == null ? 'ログイン' : 'ログアウト'),
            onTap: () {
              if (userid == null) {
                // ログイン処理
                // 例: ログイン画面にナビゲートする
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthenticationManager()),
                );
              } else {
                _signOut();
              }
            },
          ),
          if (userid != null) _buildInviteCodeTile(),
        ],
      ),
    );
  }
}
