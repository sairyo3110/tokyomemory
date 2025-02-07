import 'package:flutter/material.dart';
import 'package:mapapp/test/businesslogic/user.dart';
import 'package:mapapp/test/model/user.dart';

class UserInfoForm extends StatelessWidget {
  final UserInfoService userInfoService;
  final UserInfoRDB? userInfo;
  final bool isUserLoaded;
  final ValueChanged<UserInfoRDB> onSave;
  final VoidCallback onDelete;

  UserInfoForm({
    required this.userInfoService,
    required this.userInfo,
    required this.isUserLoaded,
    required this.onSave,
    required this.onDelete,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    late UserInfoRDB _userInfo = userInfo ??
        UserInfoRDB(
          firebaseUserId: '',
          email: '',
          name: '',
          prefecture: '',
          birthday: '',
          gender: '',
        );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('User Info:'),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _userInfo.name,
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (value) {
                    _userInfo = _userInfo.copyWith(name: value);
                  },
                ),
                TextFormField(
                  initialValue: _userInfo.prefecture,
                  decoration: InputDecoration(labelText: 'Prefecture'),
                  onSaved: (value) {
                    _userInfo = _userInfo.copyWith(prefecture: value);
                  },
                ),
                TextFormField(
                  initialValue: _userInfo.birthday,
                  decoration: InputDecoration(labelText: 'Birthday'),
                  onSaved: (value) {
                    _userInfo = _userInfo.copyWith(birthday: value);
                  },
                ),
                TextFormField(
                  initialValue: _userInfo.gender,
                  decoration: InputDecoration(labelText: 'Gender'),
                  onSaved: (value) {
                    _userInfo = _userInfo.copyWith(gender: value);
                  },
                ),
                Row(
                  children: [
                    if (isUserLoaded) ...[
                      ElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.save();
                          userInfoService.updateUserInfo(_userInfo).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('User info updated')));
                            onSave(_userInfo);
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Failed to update user info: $error')));
                          });
                        },
                        child: Text('Save'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          userInfoService
                              .deleteUserInfo(_userInfo.firebaseUserId ?? "")
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('User info deleted')));
                            onDelete();
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Failed to delete user info: $error')));
                          });
                        },
                        child: Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
                if (!isUserLoaded) ...[
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.save();
                      userInfoService.addUserInfo(_userInfo).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User info added')));
                        onSave(_userInfo);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Failed to add user info: $error')));
                      });
                    },
                    child: Text('Add New User'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
