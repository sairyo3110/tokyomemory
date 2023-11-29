import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class ProfileSettingsScreen extends StatefulWidget {
  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  Map<String, String> userAttributes = {};

  String? selectedGender;
  final List<String> genderOptions = ['男性', '女性', 'その他'];

  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;
  final List<int> years =
      List.generate(121, (index) => 1900 + index); // 1900年から2020年まで
  final List<int> months = List.generate(12, (index) => 1 + index); // 1月から12月まで
  final List<int> days = List.generate(31, (index) => 1 + index); // 1日から31日まで

  String? selectedPrefecture;
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

  @override
  void initState() {
    super.initState();
    fetchCurrentUserAttributes();
  }

  Future<void> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      Map<String, String> attributes = {};
      for (final element in result) {
        String keyName = element.userAttributeKey
            .toString()
            .replaceAll('CognitoUserAttributeKey "', '')
            .replaceAll('"', '');
        attributes[keyName] = element.value;
      }
      setState(() {
        userAttributes = attributes;
      });
    } on AuthException catch (e) {
      print('Error fetching user attributes: ${e.message}');
    }
  }

  Future<void> updateUserAttribute(
      AuthUserAttributeKey key, String newValue) async {
    try {
      List<AuthUserAttribute> attributes = [
        AuthUserAttribute(userAttributeKey: key, value: newValue)
      ];
      await Amplify.Auth.updateUserAttributes(attributes: attributes);
      fetchCurrentUserAttributes();
    } on AuthException catch (e) {
      print('Error updating attribute: ${e.message}');
    }
  }

  void showUpdateAttributeDialog(String title, AuthUserAttributeKey key,
      TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: '新しい値'),
        ),
        actions: [
          TextButton(
            child: Text('キャンセル'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('更新'),
            onPressed: () async {
              await updateUserAttribute(key, controller.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDatePickerDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    selectedYear = years[index];
                  },
                  children: List<Widget>.generate(years.length, (int index) {
                    return Center(
                      child: Text(
                        years[index].toString(),
                      ),
                    );
                  }),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    selectedMonth = months[index];
                  },
                  children: List<Widget>.generate(months.length, (int index) {
                    return Center(
                      child: Text(
                        months[index].toString(),
                      ),
                    );
                  }),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    selectedDay = days[index];
                  },
                  children: List<Widget>.generate(days.length, (int index) {
                    return Center(
                      child: Text(
                        days[index].toString(),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) async {
      if (selectedYear != null &&
          selectedMonth != null &&
          selectedDay != null) {
        String formattedDate = "$selectedYear-$selectedMonth-$selectedDay";
        await updateUserAttribute(
            AuthUserAttributeKey.birthdate, formattedDate);
        fetchCurrentUserAttributes();
      }
    });
  }

  void _showPickerDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) async {
              await updateUserAttribute(
                  AuthUserAttributeKey.address, prefectures[index]);
              setState(() {
                selectedPrefecture = prefectures[index];
              });
            },
            children: List<Widget>.generate(prefectures.length, (int index) {
              return Center(
                child: Text(
                  prefectures[index],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void deleteUser() async {
    try {
      await Amplify.Auth.deleteUser();
      print('User deleted successfully');
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 16),
              Text(
                "プロフィール詳細",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ListTile(
            title: Text('都道府県変更'),
            onTap: () => _showPickerDialog(context),
            trailing:
                Text(selectedPrefecture ?? userAttributes['address'] ?? '未選択'),
          ),
          ListTile(
            title: Text('性別変更'),
            trailing: DropdownButton<String>(
              onChanged: (value) async {
                if (value != null) {
                  await updateUserAttribute(AuthUserAttributeKey.gender, value);
                  setState(() {
                    selectedGender = value;
                  });
                }
              },
              value: userAttributes['gender'],
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
            title: Text('誕生日変更'),
            onTap: () => _showDatePickerDialog(context),
            trailing: Text(userAttributes['birthdate'] ?? '未設定'),
          ),
          // ユーザーを削除するボタンを追加
          ListTile(
            title: Text('アカウント削除', style: TextStyle(color: Colors.red)),
            onTap: () {
              // 確認ダイアログを表示
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('確認'),
                  content: Text('本当にアカウントを削除しますか？'),
                  actions: [
                    TextButton(
                      child: Text('キャンセル'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('削除', style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        deleteUser();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
            trailing: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
