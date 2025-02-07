import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mapapp/test/businesslogic/user.dart';
import 'package:mapapp/test/model/user.dart';

void showPrefecturePickerDialog(BuildContext context,
    UserInfoService userInfoService, VoidCallback onComplete) {
  final List<String> prefectures = [
    '北海道',
    '青森県',
    '岩手県',
    '宮城県',
    '秋田県',
    '山形県',
    '福島県',
    '茨城県',
    '栃木県',
    '群馬県',
    '埼玉県',
    '千葉県',
    '東京都',
    '神奈川県',
    '新潟県',
    '富山県',
    '石川県',
    '福井県',
    '山梨県',
    '長野県',
    '岐阜県',
    '静岡県',
    '愛知県',
    '三重県',
    '滋賀県',
    '京都府',
    '大阪府',
    '兵庫県',
    '奈良県',
    '和歌山県',
    '鳥取県',
    '島根県',
    '岡山県',
    '広島県',
    '山口県',
    '徳島県',
    '香川県',
    '愛媛県',
    '高知県',
    '福岡県',
    '佐賀県',
    '長崎県',
    '熊本県',
    '大分県',
    '宮崎県',
    '鹿児島県',
    '沖縄県'
  ];

  String selectedPrefecture = prefectures[0];

  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 250,
          padding: const EdgeInsets.only(top: 6.0),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: Text('確定'),
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          UserInfoRDB updatedUserInfo = UserInfoRDB(
                            firebaseUserId: user.uid,
                            email: '',
                            name: '',
                            prefecture: selectedPrefecture,
                            birthday: '',
                            gender: '',
                          );
                          await userInfoService.updateUserInfo(updatedUserInfo);
                        }
                        onComplete(); // ProfileEditの値を更新
                        Navigator.of(context).pop(); // ダイアログを閉じる
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        selectedPrefecture = prefectures[index];
                      });
                    },
                    children:
                        List<Widget>.generate(prefectures.length, (int index) {
                      return Center(
                        child: Text(prefectures[index]),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

void showGenderPickerDialog(BuildContext context,
    UserInfoService userInfoService, VoidCallback onComplete) {
  final List<String> genderOptions = ['male', 'female', 'その他'];
  String selectedGender = genderOptions[0];

  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 250,
          padding: const EdgeInsets.only(top: 6.0),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: Text('確定'),
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          UserInfoRDB updatedUserInfo = UserInfoRDB(
                            firebaseUserId: user.uid,
                            email: '',
                            name: '',
                            prefecture: '',
                            birthday: '',
                            gender: selectedGender,
                          );
                          await userInfoService.updateUserInfo(updatedUserInfo);
                        }
                        onComplete(); // ProfileEditの値を更新
                        Navigator.of(context).pop(); // ダイアログを閉じる
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        selectedGender = genderOptions[index];
                      });
                    },
                    children: List<Widget>.generate(genderOptions.length,
                        (int index) {
                      return Center(
                        child: Text(genderOptions[index]),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

void showBirthdatePickerDialog(BuildContext context,
    UserInfoService userInfoService, VoidCallback onComplete) {
  final List<int> years = List<int>.generate(51, (index) => 1970 + index);
  final List<int> months = List<int>.generate(12, (index) => 1 + index);
  final List<int> days = List<int>.generate(31, (index) => 1 + index);

  int selectedYear = years[0];
  int selectedMonth = months[0];
  int selectedDay = days[0];

  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 250,
          padding: const EdgeInsets.only(top: 6.0),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: Text('確定'),
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          String formattedDate =
                              "$selectedYear-$selectedMonth-$selectedDay";
                          UserInfoRDB updatedUserInfo = UserInfoRDB(
                            firebaseUserId: user.uid,
                            email: '',
                            name: '',
                            prefecture: '',
                            birthday: formattedDate,
                            gender: '',
                          );
                          await userInfoService.updateUserInfo(updatedUserInfo);
                        }
                        onComplete(); // ProfileEditの値を更新
                        Navigator.of(context).pop(); // ダイアログを閉じる
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32.0,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedYear = years[index];
                            });
                          },
                          children:
                              List<Widget>.generate(years.length, (int index) {
                            return Center(
                              child: Text(years[index].toString()),
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32.0,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedMonth = months[index];
                            });
                          },
                          children:
                              List<Widget>.generate(months.length, (int index) {
                            return Center(
                              child: Text(months[index].toString()),
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32.0,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedDay = days[index];
                            });
                          },
                          children:
                              List<Widget>.generate(days.length, (int index) {
                            return Center(
                              child: Text(days[index].toString()),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
