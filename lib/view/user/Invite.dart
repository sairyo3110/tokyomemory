import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/component/user_ivitescode_dialog.dart';
import 'package:mapapp/component/user_ivitesincode_dialog.dart';
import 'package:mapapp/model/Invitecode.dart';
import 'package:mapapp/repository/ivaite_controller.dart';

class InviteCodeScreen extends StatefulWidget {
  @override
  _InviteCodeScreenState createState() => _InviteCodeScreenState();
}

class _InviteCodeScreenState extends State<InviteCodeScreen> {
  String? username;
  String? userid;
  String? inviteCode;
  bool isLoading = false;
  List<InviteCode> inviteCodes = []; // 招待コードのリスト
  List<UsedInviteCode> usedInviteCodes = []; // 使用済み招待コードのリスト

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadUserid();
    _fetchInviteCodes();
    _fetchUsedInviteCodes();
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
      body: ListView(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
            ),
          ),
          Center(
            child: Text('招待機能について', style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text('アプリに招待する！'),
            onTap: () async {
              if (!isLoading) {
                String? currentUserId = await getCurrentUserId();
                if (!inviteCodes.any((code) => code.userId == currentUserId) &&
                    !usedInviteCodes
                        .any((code) => code.userId == currentUserId)) {
                  await _createInviteCode();
                }
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) =>
                      UserIvitateDialog(parentContext: context),
                ).then((_) {
                  _fetchInviteCodes();
                });
              }
            },
            trailing: isLoading ? CircularProgressIndicator() : null,
          ),
          SizedBox(height: 16),
          _buildInviteCodeTile(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
