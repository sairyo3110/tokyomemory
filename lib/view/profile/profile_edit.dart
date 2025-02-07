import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/test/businesslogic/user.dart';
import 'package:mapapp/test/repositories/user_repository.dart';
import 'package:mapapp/view/profile/widget/dialog_utils.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/profile/widget/text.dart';
import 'package:mapapp/view/search/spot/widget/list/line.dart';
import 'package:mapapp/test/model/user.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final UserInfoService userInfoService =
      UserInfoService(userInfoRepository: UserInfoRepository());

  UserInfoRDB? _userInfo;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userInfo = await userInfoService.fetchUserInfo(user.uid);
      setState(() {
        _userInfo = userInfo['user'] as UserInfoRDB?;
      });
    }
  }

  void _updateUserInfo() {
    _fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'プロフィール編集',
        showBackButton: true,
      ),
      body: BaseScreen(
        body: Container(
          padding: EdgeInsets.all(40),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('プロフィール'),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileTapTextWidget(
                      text: 'ニックネーム: ${_userInfo?.name ?? '未設定'}',
                      onTap: () => showPrefecturePickerDialog(
                          context, userInfoService, _updateUserInfo),
                    ),
                    SpotLine(),
                    ProfileTapTextWidget(
                      text: 'トーメモID: ${_userInfo?.firebaseUserId ?? '未設定'}',
                      onTap: () => showGenderPickerDialog(
                          context, userInfoService, _updateUserInfo),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Text('詳細情報'),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileTapTextWidget(
                      text: 'メインエリア: ${_userInfo?.prefecture ?? '未設定'}',
                      onTap: () => showPrefecturePickerDialog(
                          context, userInfoService, _updateUserInfo),
                    ),
                    SpotLine(),
                    ProfileTapTextWidget(
                      text: '性別: ${_userInfo?.gender ?? '未設定'}',
                      onTap: () => showGenderPickerDialog(
                          context, userInfoService, _updateUserInfo),
                    ),
                    SpotLine(),
                    ProfileTapTextWidget(
                      text: 'お誕生日: ${_userInfo?.birthday ?? '未設定'}',
                      onTap: () => showBirthdatePickerDialog(
                          context, userInfoService, _updateUserInfo),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
