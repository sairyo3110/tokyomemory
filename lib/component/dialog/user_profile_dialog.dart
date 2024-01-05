import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:mapapp/component/dialog/user_ivitesincode_dialog.dart';

class UserProfileUpdateDialog extends StatefulWidget {
  final BuildContext parentContext;

  UserProfileUpdateDialog({required this.parentContext});

  @override
  _UserProfileUpdateDialogState createState() =>
      _UserProfileUpdateDialogState();
}

class _UserProfileUpdateDialogState extends State<UserProfileUpdateDialog> {
  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;
  String? selectedPrefecture;
  final List<String> genderOptions = ['男性', '女性', '未選択'];
  final List<int> years = List.generate(61, (index) => 1950 + index);
  final List<int> months = List.generate(12, (index) => 1 + index);
  final List<int> days = List.generate(31, (index) => 1 + index);
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
  ]; // 省略: 都道府県のリスト

  Map<String, String> userAttributes = {};

  Future<void> updateUserAttribute(
      AuthUserAttributeKey key, String newValue) async {
    try {
      List<AuthUserAttribute> attributes = [
        AuthUserAttribute(userAttributeKey: key, value: newValue)
      ];
      await Amplify.Auth.updateUserAttributes(attributes: attributes);
    } on AuthException catch (e) {
      print('Error updating attribute: ${e.message}');
    }
  }

  void _showDatePickerDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 256, // 高さを調整してボタンのスペースを確保
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // 決定ボタン
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(right: 10.0),
                  child: CupertinoButton(
                    child: Text('決定'),
                    onPressed: () {
                      Navigator.of(context).pop(); // ダイアログを閉じる
                      if (selectedYear != null &&
                          selectedMonth != null &&
                          selectedDay != null) {
                        String formattedDate =
                            "${selectedYear.toString()}-${selectedMonth.toString().padLeft(2, '0')}-${selectedDay.toString().padLeft(2, '0')}";
                        updateUserAttribute(
                            AuthUserAttributeKey.birthdate, formattedDate);
                        setState(() {
                          userAttributes['birthdate'] = formattedDate;
                        });
                      }
                    },
                  ),
                ),
                // Picker
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 年選択
                      _buildDatePickerComponent(
                          years, (index) => selectedYear = years[index]),
                      // 月選択
                      _buildDatePickerComponent(
                          months, (index) => selectedMonth = months[index]),
                      // 日選択
                      _buildDatePickerComponent(
                          days, (index) => selectedDay = days[index]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Pickerコンポーネントの生成を効率化するためのヘルパーメソッド
  Widget _buildDatePickerComponent(
      List<int> items, Function(int) onSelectedItemChanged) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      child: CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32.0,
        onSelectedItemChanged: onSelectedItemChanged,
        children: List<Widget>.generate(items.length, (int index) {
          return Center(
            child: Text(
              items[index].toString(),
            ),
          );
        }),
      ),
    );
  }

  void _showPickerDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 256, // 高さを調整してボタンのスペースを確保
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // 決定ボタン
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(right: 10.0),
                  child: CupertinoButton(
                    child: Text('決定'),
                    onPressed: () {
                      Navigator.of(context).pop(); // ダイアログを閉じる
                      if (selectedPrefecture != null) {
                        updateUserAttribute(
                            AuthUserAttributeKey.address, selectedPrefecture!);
                      }
                    },
                  ),
                ),
                // Picker
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
                        child: Text(
                          prefectures[index],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'プロフィール設定のお知らせ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            SizedBox(height: 15),
            Text(
              'ユーザーの登録ありがとうございます！',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'アプリをより良くするために',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            Text(
              '・都道府県',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              '・性別',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              '・誕生日',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              'の入力をお願いします。',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('都道府県'),
              onTap: _showPickerDialog,
              trailing: Text(
                  selectedPrefecture ?? userAttributes['address'] ?? '未選択'),
            ),
            ListTile(
              title: Text('性別'),
              trailing: DropdownButton<String>(
                onChanged: (value) async {
                  if (value != null && value != '未選択') {
                    await updateUserAttribute(
                        AuthUserAttributeKey.gender, value);
                    setState(() {
                      userAttributes['gender'] = value;
                    });
                  }
                },
                value: userAttributes['gender'] ?? '未選択',
                items:
                    genderOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text('誕生日'),
              onTap: _showDatePickerDialog,
              trailing: Text(userAttributes['birthdate'] ?? '未設定'),
            ),
            ListTile(
              title: Text('招待コードがある方はここをタップ'),
              onTap: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    UserIvitateIncodeDialog(parentContext: context),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('スキップ'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('保存'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
