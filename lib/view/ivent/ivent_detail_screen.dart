import 'dart:math';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/model/clickinfo.dart';
import 'package:mapapp/repository/clickInfo_controller.dart';
import 'package:mapapp/model/rerated_model.dart';
import 'package:mapapp/view/coupon/coupon_detail_screen.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

// ignore: must_be_immutable
class IventDetailScreen extends StatelessWidget {
  final PlaceDetail spot;
  final List<PlaceDetail> coupons = [];

  bool isAndroid = Platform.isAndroid;
  bool isIOS = Platform.isIOS;

  IventDetailScreen({required this.spot});

  final ClickInfoController _clickInfoController = ClickInfoController();

  void _sharePage(BuildContext context) {
    final String deepLinkUrl = 'mapapp://ivent/${spot.placeId}';
    const String AndroidLinkUrl =
        'https://play.google.com/store/apps/details?id=tokyomemory.mapapp0918&pli=1';
    final String IOSLinkUrl =
        'https://apps.apple.com/jp/app/tokyo-memory/id6466747873';
    if (isAndroid) {
      Share.share(
          'ここ行きたい！\n\n${spot.name}\n\n▼ここから見てみて！\n${deepLinkUrl}\n\nアプリをダウンロードしていない場合はここから▼\n${AndroidLinkUrl}');
    }
    if (isIOS) {
      Share.share(
          'ここ行きたい！\n\n${spot.name}\n\n▼ここから見てみて！\n${deepLinkUrl}\n\nアプリをダウンロードしていない場合はここから▼\n${IOSLinkUrl}');
    }
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
    print('Coupon ID: ${spot.couponId}');
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: (450 * 9) /
                  16, // Calculate height based on a 16:9 aspect ratio
              width: MediaQuery.of(context)
                  .size
                  .width, // Set width to the screen width
              child: Stack(
                alignment: Alignment
                    .center, // This aligns the text to the center of the stack
                children: [
                  ListView.builder(
                    scrollDirection: Axis.horizontal, // 横方向にスクロール
                    itemCount: 2, // 2枚の画像
                    itemBuilder: (context, index) {
                      String imageUrl = index == 0
                          ? 'https://mymapapp.s3.ap-northeast-1.amazonaws.com/ivent/${spot.placeId}/1.png'
                          : 'https://mymapapp.s3.ap-northeast-1.amazonaws.com/ivent/${spot.placeId}/2.png';

                      return Container(
                        width: MediaQuery.of(context).size.width, // 画面の幅に合わせる
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: FadeInImage.assetNetwork(
                            placeholder:
                                'images/noimage.png', // プレースホルダーとして使用する画像
                            image: imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 45,
                    left: 0,
                    right: 10,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // これで左寄せと右寄せになります
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _sharePage(context),
                          icon: Icon(
                            Icons.ios_share,
                            size: 15,
                          ),
                          label: Text(
                            '送る',
                            style: TextStyle(fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black45, // ボタンの背景色
                            onPrimary: Color(0xFFF6E6DC), // ボタンのテキスト色
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // 角の丸みを20の半径で設定
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(4.0), // 全体の余白を追加
              padding: EdgeInsets.all(8.0), // 内側の余白を追加
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '※公式HPより引用',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // これで左寄せと右寄せになります
                      children: [
                        Container(
                          width: 250.0, // ここに横幅を指定します
                          child: Text(
                            spot.name ?? '',
                            style: TextStyle(
                              color: Color(0xFFF6E6DC),
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2, // 最大行数を指定します
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            launch(
                                'https://www.google.com/maps/search/?api=1&query=${spot.paLatitude ?? 0},${spot.paLongitude ?? 0}');
                          },
                          icon: Icon(
                            Icons.pin_drop,
                            size: 14,
                          ),
                          label: Text(
                            '経路を表示',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF6E6DC), // ボタンの背景色
                            onPrimary: Colors.black, // ボタンのテキスト色
                            // 他にも影の色や形状などを設定できます
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${spot.city ?? ''}${spot.chome ?? ''}${(spot.banchi?.isEmpty ?? true) ? '' : '-'}${spot.banchi ?? ''}${(spot.go?.isEmpty ?? true) ? '' : '-'}${spot.go ?? ''}${spot.buildingName ?? ''}',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    const Text(
                      '魅力ポイント',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      spot.description ?? '',
                      style: TextStyle(fontSize: 12),
                    ),
                    Divider(),
                    const Text(
                      '開催期間',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      spot.address ?? '',
                      style: TextStyle(fontSize: 12),
                    ),
                    Divider(),
                    const Text(
                      'アクセス',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      spot.nearestStation! +
                          (spot.walkingMinutes != null
                              ? 'より ${spot.walkingMinutes}分'
                              : 'よりすぐ'),
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Divider(),
                    const Text(
                      '営業時間',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                            size: 15.0,
                            Icons
                                .schedule), // Another desired icon for night time
                        SizedBox(width: 5),
                        Text(
                            (spot.nightStart == null || spot.nightEnd == null
                                ? '更新中'
                                : '${formatTime(spot.nightStart)} - ${formatTime(spot.nightEnd)}'),
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
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          size: 15.0,
                          Icons.currency_yen,
                        ), // Add your desired icon
                        SizedBox(width: 5),
                        Text(
                          () {
                            double minPrice = [
                              spot.dayMax,
                              spot.dayMin,
                              spot.nightMin,
                              spot.nightMax,
                            ]
                                .where(
                                    (value) => value != null) // nullでない値のみを取得
                                .map((value) =>
                                    double.tryParse(value ?? '0') ??
                                    0) // 数値に変換し、nullの場合は0を使用
                                .reduce(min); // 最小値を取得

                            return minPrice == 0
                                ? '無料'
                                : '${minPrice.toInt()}円から〜';
                          }(),
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      '公式or予約サイト',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Save the click info
                        final String? userId = await getCurrentUserId();

                        if (userId != null) {
                          final ClickInfo clickInfo = ClickInfo(
                            spotId: spot.placeId ?? 0,
                            userId: userId,
                            clickedAt: DateTime.now(),
                          );
                          await _clickInfoController.saveClickInfo(clickInfo);
                        } else {
                          print("Error: Unable to fetch user ID from Cognito");
                        }

                        // Launch the reservation site
                        if (await canLaunch(spot.reservationSite ?? '')) {
                          await launch(spot.reservationSite ?? '');
                        }
                      },
                      child: Text(
                        spot.reservationSite ?? '',
                        style: TextStyle(color: Color(0xFFF6E6DC)),
                      ),
                    ),
                    Divider(),
                  ]),
            ),
            if ((spot.cCouponId ?? 0) != 0)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CouponDetailScreen(coupon: spot),
                    ),
                  );
                },
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Text('このお店のクーポンはこちらから▼'),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width, // 画面の幅に合わせる
                      height: MediaQuery.of(context).size.width * 0.45,
                      child: Center(
                        child: Image.network(
                          "https://mymapapp.s3.ap-northeast-1.amazonaws.com/coupon/${spot.name}/1.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
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
}
