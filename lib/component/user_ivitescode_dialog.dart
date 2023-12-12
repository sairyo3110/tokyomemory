import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/model/Invitecode.dart';
import 'package:mapapp/repository/ivaite_controller.dart';
import 'package:share/share.dart';
import 'package:collection/collection.dart';

class UserIvitateDialog extends StatefulWidget {
  final BuildContext parentContext;

  UserIvitateDialog({required this.parentContext});

  @override
  _UserIvitateDialogState createState() => _UserIvitateDialogState();
}

class _UserIvitateDialogState extends State<UserIvitateDialog> {
  String? username;
  String? userid;
  String? inviteCode;
  bool isLoading = false;
  List<InviteCode> inviteCodes = []; // 招待コードのリスト
  List<UsedInviteCode> usedInviteCodes = []; // 使用済み招待コードのリスト
  int usedInviteCodesCount = 0;

  bool isAndroid = Platform.isAndroid;
  bool isIOS = Platform.isIOS;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadUserid();
    _fetchInviteCodes();
    _fetchUsedInviteCodes();
  }

  Future<void> _sharePage(BuildContext context) async {
    String? currentUserId = await getCurrentUserId();
    List<InviteCode> currentUserInviteCodes =
        inviteCodes.where((code) => code.userId == currentUserId).toList();
    String inviteCodesString =
        currentUserInviteCodes.map((code) => code.code).join(', ');

    const String AndroidLinkUrl =
        'https://play.google.com/store/apps/details?id=tokyomemory.mapapp0918&pli=1';
    final String IOSLinkUrl =
        'https://apps.apple.com/jp/app/tokyo-memory/id6466747873';
    Share.share(
        '地名やカテゴリからデートを探せる『Tokyo Memory』\n\nアプリダウンロード後に招待コードを入力した方に、抽選でディズニーペアチケットをプレゼント！\n\n▼招待コード\n${inviteCodesString}\n\nここから無料でダウンロード！\n\n▼iphoneの方はこちら\n${IOSLinkUrl}\n\n▼androidの方はこちら\n${AndroidLinkUrl}');
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

  Future<String?> _fetchMyInviteCode() async {
    String? currentUserId = await getCurrentUserId();
    var myInviteCode =
        inviteCodes.firstWhereOrNull((code) => code.userId == currentUserId);
    return myInviteCode?.code;
  }

  Future<void> _fetchUsedInviteCodes() async {
    setState(() {
      isLoading = true;
    });

    try {
      var fetchedUsedInviteCodes = await fetchUsedInviteCodes();
      String? myCode = await _fetchMyInviteCode();
      if (mounted) {
        setState(() {
          usedInviteCodes = fetchedUsedInviteCodes;
          usedInviteCodesCount =
              usedInviteCodes.where((code) => code.code == myCode).length;
          print(usedInviteCodesCount);
        });
      }
    } catch (e) {
      print('Error fetching used invite codes: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<Widget> _buildInviteCodeWidgets() {
    List<Widget> widgets = []; // ウィジェットを保存するためのリストを作成

    if (usedInviteCodes.isNotEmpty &&
        usedInviteCodes.any((code) => code.userId == userid)) {
      for (var code in usedInviteCodes.where((code) => code.userId == userid)) {
        widgets.add(ListTile(
          // ListTileをリストに追加
          title: Text(
            code.inviteCode,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center, // この行を追加
          ),
        ));
      }
    } else if (inviteCodes.isNotEmpty &&
        inviteCodes.any((code) => code.userId == userid)) {
      for (var code in inviteCodes.where((code) => code.userId == userid)) {
        widgets.add(ListTile(
          // ListTileをリストに追加
          title: Text(
            code.code,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center, // この行を追加
          ),
        ));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '友達を招待して豪華賞品ゲット！',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            SizedBox(height: 15),
            Text(
              '①招待コードを送る',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'まだ、Tokyo memoryをダウンロードしていない友達に招待コードを送ろう！',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '②お互いに報酬GET！',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '相手が招待コードを入力して会員登録をすると1ポイントGET！',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '③報酬をGET！',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '10ポイント貯めると、先着100名様にスタバギフト券500円分プレゼント！',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'さらに、期間中に1番友達を招待した方には旅行券2万円分、2位の方には旅行券5000円分、3位の方には旅行券3000円分をプレゼント！',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '招待コードを送るボタンから友達を招待しよう！',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '招待された側にはディズニーペアチケットが当たる抽選券をプレゼント！',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            Text(
              '招待する側もされた側もWIN-WIN！',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.8, // この行を追加
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFF6E6DC),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                      '▼あなたの招待コード▼',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ..._buildInviteCodeWidgets(),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sharePage(context);
              },
              child: Text(
                '招待コードを送る',
                style: TextStyle(fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF6E6DC), // ボタンの背景色
                onPrimary: Colors.black, // ボタンのテキスト色
                // 他にも影の色や形状などを設定できます
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'あなたの招待コードが使われた回数: $usedInviteCodesCount回',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              '※先着100名に到達次第、本キャンペーンは終了いたします。',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              '※不正が発覚した場合は当選を見送らせていただきます',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('閉じる'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
