import 'dart:convert';
import 'dart:math';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/component/bottan/favorite_bottan.dart';
import 'package:mapapp/component/dialog/user_ivitescode_dialog.dart';
import 'package:mapapp/component/dialog/user_ivitesincode_dialog.dart';
import 'package:mapapp/model/Invitecode.dart';
import 'package:mapapp/repository/favorite_controller.dart';
import 'package:mapapp/repository/ivaite_controller.dart';
import 'package:mapapp/provider/places_provider.dart';
import 'package:mapapp/model/rerated_model.dart';
import 'package:mapapp/view/authenticator/authenticator_service.dart';
import 'package:mapapp/view/spot/spot_detail_screen.dart';
import 'package:mapapp/view/user/settings.dart';
import 'dart:io' show Platform;

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
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
  double _appBarHeight = 80.0;
  Alignment _alignment = Alignment.centerLeft;
  double _fontSize = 40.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadUsername();
    _loadUserid();
    _fetchInviteCodes();
    _fetchUsedInviteCodes();
    _loadFavoriteSpots();
    _scrollController.addListener(() {
      // スクロールが最下部に達したかどうかをチェック
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // スクロールが最下部に達したら、_loadFavoriteSpots関数を呼び出す
        _loadFavoriteSpots();
      }
    });
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _appBarHeight = max(50.0, 60.0 - offset); // スクロールに応じてAppBarの高さを変更
      _fontSize = max(20.0, 40.0 - offset); // スクロールに応じてフォントサイズを変更
      if (offset > 20.0) {
        // 20.0は適当な閾値、実際には適切な値を設定する必要があります
        _alignment = Alignment.center; // スクロールが一定量進んだらセンターに配置
      } else {
        _alignment = Alignment.centerLeft; // それ以外の場合は左寄せ
      }
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

  Widget _loginButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthenticationManager()),
          );
        },
        child: Text('ログイン'),
      ),
    );
  }

  Future<void> _loadFavoriteSpots() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? userId = await getCurrentUserId();
      if (userId != null) {
        var favoriteIds = await fetchFavorites(userId);
        var placesProvider = PlacesProvider();
        var places =
            await placesProvider.fetchFilteredPlaceDetails(favoriteIds);
        setState(() {
          favoritePlaces = places;
        });
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight), // AppBarの縦幅を100.0に設定
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: EdgeInsets.all(8.0), // 余白を追加
            alignment: _alignment, // alignmentを動的に設定
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0), // 上に10.0の余白を追加
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // 左右に寄せる
                  children: [
                    Text("Setting"),
                    SizedBox(width: 10.0), // 左に10.0の余白を追加
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingMainScreen()),
                        );
                      },
                      child: Icon(
                        Icons.settings,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          elevation: 0, // 影を消す
        ),
      ),
      body: userid == null
          ? _loginButton() // ユーザーIDがnullの場合、ログインボタンを表示
          : ListView(
              controller: _scrollController, // ScrollControllerを指定
              physics: AlwaysScrollableScrollPhysics(), // スクロールを常に有効にする
              children: [
                ListTile(
                  title: Text('お知らせ'),
                ),
                InkWell(
                  onTap: () async {
                    if (!isLoading) {
                      String? currentUserId = await getCurrentUserId();
                      if (!inviteCodes
                              .any((code) => code.userId == currentUserId) &&
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
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Align(
                          widthFactor: 0.6, // ここを調整してカードの横幅を制御します
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'images/ivites.png',
                                width: 370, // ここを調整して画像のサイズを一回り小さくします
                                height: 210, // ここも同様に調整します
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                ),
                Column(
                  children: [
                    ListTile(
                      title: Text('お気に入りスポット'),
                    ),
                    ListView.builder(
                      shrinkWrap: true, // ListViewが親のサイズに合わせてサイズを調整する
                      physics:
                          NeverScrollableScrollPhysics(), // ListViewのスクロールを無効にする
                      itemCount:
                          favoritePlaces.length, // favoritePlacesリストの長さを使用
                      itemBuilder: (context, index) {
                        final spot =
                            favoritePlaces[index]; // favoritePlacesリストからスポットを取得
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SpotDetailScreen(
                                    parentContext: context, spot: spot),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.all(10.0), // カードの周りにマージンを追加
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15.0), // 角丸の設定
                            ),
                            elevation: 3.0, // 影を付ける
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 10), // 左側にのみパディングを適用
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 140.0, // 画像の幅
                                    height: 140.0, // 画像の高さ
                                    child: (spot.imageUrl?.isEmpty ?? true)
                                        ? Image(
                                            image: AssetImage(
                                                'images/noimage.png'),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.imageUrl}/1.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0), // テキストセクションのパディング
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    spot.name ?? '',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis, // タイトルが長い場合は省略記号を表示
                                                  ),
                                                ),
                                                FavoriteIconWidget(
                                                  userId: userid!,
                                                  placeId: spot.placeId ??
                                                      0, // 実際の場所IDを設定する
                                                  isFavorite:
                                                      false, // お気に入り状態を設定する
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(children: <Widget>[
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0,
                                                            vertical: 4.0),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF6E6DC),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child: Text(
                                                      (spot.pcsName ?? '更新中'),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  if ((spot.cCouponId ?? 0) !=
                                                      0)
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0,
                                                              vertical: 4.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      child: Text(
                                                        'クーポン',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                ]),
                                                SizedBox(height: 10),
                                                Text(
                                                  '${spot.city}/${spot.nearestStation}',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        size: 15.0,
                                                        Icons
                                                            .directions_walk), // Add your desired icon
                                                    Text(
                                                      ('${spot.nearestStation}より ${spot.walkingMinutes}分'),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Icon(
                                                        size: 15.0,
                                                        Icons
                                                            .currency_yen), // Add your desired icon
                                                    Text(
                                                      (double.tryParse(spot.dayMin ??
                                                                          '0')
                                                                      ?.toInt() ==
                                                                  0 &&
                                                              double.tryParse(
                                                                          spot.dayMax ??
                                                                              '0')
                                                                      ?.toInt() ==
                                                                  0)
                                                          ? '${double.tryParse(spot.nightMin ?? '0')?.toInt()}円 - ${double.tryParse(spot.nightMax ?? '0')?.toInt()}円'
                                                          : '${double.tryParse(spot.dayMin ?? '0')?.toInt()}円 - ${double.tryParse(spot.dayMax ?? '0')?.toInt()}円',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 30),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 400,
                    )
                  ],
                ),
              ],
            ),
    );
  }
}
