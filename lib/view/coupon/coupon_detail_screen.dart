import 'dart:math';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/amplifyconfiguration.dart';
import 'package:mapapp/model/coupon_usage.dart';
import 'package:mapapp/model/rerated_model.dart';
import 'package:mapapp/repository/coupon_usage_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CouponDetailScreen extends StatefulWidget {
  final PlaceDetail coupon;

  CouponDetailScreen({required this.coupon});

  @override
  _CouponDetailScreenState createState() => _CouponDetailScreenState();
}

class _CouponDetailScreenState extends State<CouponDetailScreen> {
  bool isFavorited = false;
  bool isUsed = false;
  bool showPlaceDetails = false;
  bool signedIn = false;
  List<CouponUsage>? _couponUsages; // <- こちらを追加

  final ScrollController _scrollController = ScrollController();
  double _appBarHeight = 60.0;
  double _fontSize = 20.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchCouponUsage();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _appBarHeight = max(45.0, 60.0 - offset); // スクロールに応じてAppBarの高さを変更
      _fontSize = max(10.0, 20.0 - offset); // スクロールに応じてフォントサイズを変更
    });
  }

  String formatTime(String? time) {
    return (time != null && time.contains(':'))
        ? time.split(':')[0] + ':' + time.split(':')[1]
        : '';
  }

  String parseInt(String? value) {
    if (value == null || value.isEmpty) {
      return '更新中'; // Return '更新中' if the string is null or empty
    }
    // Try to parse the string as a double then convert to int
    try {
      var number = double.parse(value);
      return number
          .toInt()
          .toString(); // Convert to int to remove decimal points
    } catch (e) {
      return '更新中'; // In case of error, return '更新中'
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight), // AppBarの縦幅を100.0に設定
        child: AppBar(
          leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: Color(0xFFF6E6DC)), // アイコンを黒色に設定
            onPressed: () {
              Navigator.of(context).pop(); // 現在の画面をポップして前の画面に戻る
            },
          ),
          title: Container(
            padding: EdgeInsets.all(8.0), // 余白を追加
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.0), // 上に10.0の余白を追加
                Text(
                  widget.coupon.name ?? '',
                  style: TextStyle(
                    color: Color(0xFFF6E6DC), // 文字色を黒に設定
                    fontSize: _fontSize, // 文字サイズを40.0に設定
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
          backgroundColor: Color(0xFF444440), // 背景色を白に設定
          elevation: 0, // 影を消す
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // ScrollControllerを指定
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              Container(
                margin: EdgeInsets.all(8.0), // 全体の余白を追加
                padding: EdgeInsets.all(16.0), // 内側の余白を追加
                decoration: BoxDecoration(
                  color: Color(0xFF444440), // 背景色
                  borderRadius: BorderRadius.circular(8.0), // 角を丸くする
                  boxShadow: [
                    // 影を追加
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.coupon.cDescription ?? '',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.45,
                      child: Image.network(
                        "https://mymapapp.s3.ap-northeast-1.amazonaws.com/coupon/${widget.coupon.name}/1.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    isUsed
                        ? Text(
                            '使用済み',
                            style: TextStyle(
                                fontSize: 20, color: Color(0xFFF6E6DC)),
                          )
                        : Text(
                            'あと1回使用できます',
                            style: TextStyle(fontSize: 20),
                          ),
                    SizedBox(height: 10),
                    if (!isUsed) SizedBox(height: 16.0),
                    if (!isUsed)
                      Column(
                        children: [
                          Text(
                            "-クーポンを使用するには、お会計時にこの画面をスタッフに提示してください。",
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            "-使用済みのクーポンはご利用になれません。また、お客様の操作で誤って「使用済み」にしてしまった場合も利用できなくなります。",
                            style: TextStyle(fontSize: 13),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            "クーポンの有効期日日時は、UTC+9:00を基準に表示しています。",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400], // この行を追加して、色を薄い灰色に設定します
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) async {
                              setState(() {
                                isUsed = true;
                              });

                              // 現在の日時を取得
                              DateTime now = DateTime.now();

                              // CognitoからユーザーIDを取得
                              String? userId = await getCurrentUserId();

                              int? couponId = widget.coupon.cCouponId;

                              if (userId != null) {
                                // CouponUsageモデルのインスタンスを作成
                                CouponUsage usage = CouponUsage(
                                  couponId: couponId ?? 0,
                                  userId: userId,
                                  usedAt: now,
                                );

                                // ApiControllerのインスタンスを作成
                                CouponUsageController api =
                                    CouponUsageController();

                                // APIにPOSTリクエストを送信
                                api.sendCouponUsage(usage).catchError((error) {
                                  print('Error sending data: $error');
                                });

                                // デバッグコンソールに情報を表示
                                print(
                                    "$couponId.$userId.${now.toIso8601String()}");
                              } else {
                                print(
                                    "Error: Either userId or couponId is null");
                              }
                            },
                            background: slideBackground(Alignment.centerRight),
                            secondaryBackground:
                                slideBackground(Alignment.centerLeft),
                            child: Container(
                              width: 200,
                              height: 50,
                              color: Color(0xFFF6E6DC),
                              child: Center(
                                child: Text(
                                  'クーポンを使用＞',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "クーポンを使用＞を右にスライド",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              if (!isUsed)
                Text(
                  "店舗詳細情報",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              if (!isUsed)
                Container(
                  margin: EdgeInsets.all(8.0), // 全体の余白を追加
                  padding: EdgeInsets.all(16.0), // 内側の余白を追加
                  decoration: BoxDecoration(
                    color: Color(0xFF444440), // 背景色
                    borderRadius: BorderRadius.circular(8.0), // 角を丸くする
                    boxShadow: [
                      // 影を追加
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '魅力ポイント',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(widget.coupon.description ?? ''),
                      Divider(),
                      Text(
                        'アクセス',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          '${widget.coupon.nearestStation}より ${widget.coupon.walkingMinutes}分'),
                      Divider(),
                      Text(
                        '営業時間',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(size: 15.0, Icons.sunny), // Desired icon
                          Text(
                              (widget.coupon.dayStart == null ||
                                      widget.coupon.dayEnd == null)
                                  ? '更新中'
                                  : '${formatTime(widget.coupon.dayStart)} - ${formatTime(widget.coupon.dayEnd)}',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                              size: 15.0,
                              Icons
                                  .nightlight_round), // Another desired icon for night time
                          Text(
                              (widget.coupon.nightStart == null ||
                                      widget.coupon.nightEnd == null)
                                  ? '更新中'
                                  : '${formatTime(widget.coupon.nightStart)} - ${formatTime(widget.coupon.nightEnd)}',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Divider(),
                      Text(
                        '予算',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                              size: 15.0, Icons.sunny), // Add your desired icon
                          Text(
                              (widget.coupon.dayMin == null ||
                                      widget.coupon.dayMax == null)
                                  ? '更新中'
                                  : '${parseInt(widget.coupon.dayMin)}円 - ${parseInt(widget.coupon.dayMax)}円',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                              size: 15.0,
                              Icons.nightlight), // Add your desired icon
                          Text(
                              (widget.coupon.nightMin == null ||
                                      widget.coupon.nightMax == null)
                                  ? '更新中'
                                  : '${parseInt(widget.coupon.nightMin)}円 - ${parseInt(widget.coupon.nightMax)}円',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Divider(),
                      Text(
                        '予約サイト',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (await canLaunch(
                              widget.coupon.reservationSite ?? '')) {
                            await launch(widget.coupon.reservationSite ?? '');
                          }
                        },
                        child: Text(
                          widget.coupon.reservationSite ?? '',
                          style: TextStyle(color: Color(0xFFF6E6DC)),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget slideBackground(Alignment alignment) {
    return Container(
      color: Colors.grey,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: alignment == Alignment.centerRight
              ? const EdgeInsets.only(right: 16.0)
              : const EdgeInsets.only(left: 16.0),
          child: Icon(Icons.check, color: Colors.white),
        ),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  Future<void> _configure() async {
    if (!Amplify.isConfigured) {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
    }

    try {
      var currentUser = await Amplify.Auth.getCurrentUser();
      print(currentUser.userId);
      print(currentUser.username);

      var userAttributes = await Amplify.Auth.fetchUserAttributes();
      for (final element in userAttributes) {
        print('key: ${element.userAttributeKey}; value: ${element.value}');
      }

      signedIn = true;
    } on AuthException catch (e) {
      print(e);
      signedIn = false;
    }
  }

  // 以下は新しく追加されたメソッドです。
  Future<String?> getCurrentUserId() async {
    try {
      var currentUser = await Amplify.Auth.getCurrentUser();
      return currentUser.userId;
    } on AuthException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _fetchCouponUsage() async {
    try {
      // Controller のインスタンスを作成
      CouponUsageController controller = CouponUsageController();

      // APIからクーポンの使用情報を取得
      _couponUsages = await controller.getCouponUsages();

      String? userId = await getCurrentUserId();

      if (userId != null) {
        DateTime oneMonthAgo = DateTime.now().subtract(Duration(days: 30));

        for (var usage in _couponUsages!) {
          if (usage.userId == userId &&
              usage.couponId == widget.coupon.couponId &&
              usage.usedAt.isAfter(oneMonthAgo)) {
            setState(() {
              isUsed = true;
            });
            break;
          }
        }
      }
    } catch (e) {
      print("Error fetching coupon usages: $e");
    }
  }
}
