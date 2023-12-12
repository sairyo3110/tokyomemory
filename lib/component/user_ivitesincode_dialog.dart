import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/repository/ivaite_controller.dart';

class UserIvitateIncodeDialog extends StatefulWidget {
  final BuildContext parentContext;

  UserIvitateIncodeDialog({required this.parentContext});

  @override
  _UserIvitateIncodeDialogState createState() =>
      _UserIvitateIncodeDialogState();
}

class _UserIvitateIncodeDialogState extends State<UserIvitateIncodeDialog> {
  final _inviteCodeController = TextEditingController();
  bool isLoading = false;
  String? inviteInCode;
  String? inviteCode;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
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

  Future<void> _inputInviteCode() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? userId = await getCurrentUserId();
      inviteInCode = _inviteCodeController.text;
      var response = await inputInviteCode(userId ?? '', inviteInCode ?? '');

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> outerBody = json.decode(responseBody);
        Map<String, dynamic> innerBodys = outerBody['body'];
        Map<String, dynamic> innerBody = json.decode(innerBodys['body']);

        if (innerBody.containsKey('success')) {
          print('入力成功しました');
          setState(() {
            _errorMessage = null;
          });
        } else {
          print('Error: ${innerBody['error']}');
          setState(() {
            _errorMessage = '入力コードが間違えています';
          });
        }
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('招待コードを入力'),
      content: TextField(
        controller: _inviteCodeController,
        decoration: InputDecoration(
          hintText: '招待コード',
          errorText: _errorMessage, // これを追加
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('決定'),
          onPressed: () async {
            await _inputInviteCode();
            if (_errorMessage == null) {
              // この行を追加
              Navigator.of(context).pop();
              Navigator.of(widget.parentContext).setState(() {});
            }
          },
        ),
        TextButton(
          child: const Text('閉じる'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(widget.parentContext).setState(() {});
          },
        ),
      ],
    );
  }
}
