import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/component/bottan/favorite_bottan.dart';
import 'package:mapapp/importer.dart';
import 'package:mapapp/model/clickinfo.dart';
import 'package:mapapp/repository/clickInfo_controller.dart';
import 'package:mapapp/model/rerated_model.dart';
import 'package:mapapp/view/coupon/coupon_detail_screen.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class SpotDetailScreen extends StatefulWidget {
  final BuildContext parentContext;
  final PlaceDetail spot;

  SpotDetailScreen({required this.parentContext, required this.spot});

  @override
  _SpotDetailScreenState createState() => _SpotDetailScreenState(spot);
}

// ignore: must_be_immutable
class _SpotDetailScreenState extends State<SpotDetailScreen> {
  final PlaceDetail spot;
  final List<PlaceDetail> coupons = [];
  String? userid;

  _SpotDetailScreenState(this.spot);

  bool isAndroid = !kIsWeb && Platform.isAndroid; // WebではないかつAndroidの場合にtrue
  bool isIOS = !kIsWeb && Platform.isIOS; // WebではないかつiOSの場合にtrue

  bool _isDataLoaded = false;

  final ClickInfoController _clickInfoController = ClickInfoController();

  @override
  void initState() {
    super.initState();
    _loadUserid();
  }

  void _sharePage(BuildContext context) {
    final String deepLinkUrl = 'mapapp://spot/${spot.placeId}';
    const String AndroidLinkUrl =
        'https://play.google.com/store/apps/details?id=tokyomemory.mapapp0918&pli=1';
    final String IOSLinkUrl =
        'https://apps.apple.com/jp/app/tokyo-memory/id6466747873';
    if (isAndroid) {
      Share.share(
          'いい感じのお店見つけた！\n\n${spot.name}\n\n▼ここから見てみて！\n${deepLinkUrl}\n\nアプリをダウンロードしていない場合はここから▼\n${AndroidLinkUrl}');
    }
    if (isIOS) {
      Share.share(
          'いい感じのお店見つけた！\n\n${spot.name}\n\n▼ここから見てみて！\n${deepLinkUrl}\n\nアプリをダウンロードしていない場合はここから▼\n${IOSLinkUrl}');
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

  Future<void> _loadUserid() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      setState(() {
        userid = authUser.userId;
        _isDataLoaded = true; // データがロードされたことを示す
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          spot.name ?? '', // AppBarのタイトルを設定します
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis, // タイトルが長すぎる場合には省略記号（...）で表示します
        ),
        centerTitle: true, // タイトルを中央に配置します
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: (450 * 16) /
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
                          ? "https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.imageUrl}/1.png"
                          : "https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.imageUrl}/2.png";

                      return Container(
                        width: MediaQuery.of(context).size.width, // 画面の幅に合わせる
                        height:
                            MediaQuery.of(context).size.width, // 高さも画面の幅に合わせる
                        child: ClipRRect(
                          child: (spot.imageUrl?.isEmpty ?? true)
                              ? Image(
                                  image: AssetImage('images/noimage.png'),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      );
                    },
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
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // これで左寄せと右寄せになります
                      children: [
                        Text(
                          spot.name ?? '',
                          style: TextStyle(
                            color: Color(0xFFF6E6DC),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isDataLoaded)
                          if (!kIsWeb)
                            FavoriteIconWidget(
                              userId: userid ?? '',
                              placeId: spot.placeId ?? 0, // 実際の場所IDを設定する
                              isFavorite: false, // お気に入り状態を設定する
                            ),
                      ],
                    ),
                    Text(
                      '${spot.city ?? ''}${spot.chome ?? ''}${(spot.banchi?.isEmpty ?? true) ? '' : '-'}${spot.banchi ?? ''}${(spot.go?.isEmpty ?? true) ? '' : '-'}${spot.go ?? ''}${spot.buildingName ?? ''}',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
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
                        SizedBox(
                          width: 20,
                        ),
                        if (!kIsWeb)
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
                      'アクセス',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(('${spot.nearestStation}より ${spot.walkingMinutes}分'),
                        style: TextStyle(fontSize: 12)),
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
                        Icon(size: 15.0, Icons.sunny), // Desired icon
                        Text(
                            (spot.dayStart == null || spot.dayEnd == null)
                                ? '更新中'
                                : '${formatTime(spot.dayStart)} - ${formatTime(spot.dayEnd)}',
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
                            (spot.nightStart == null || spot.nightEnd == null)
                                ? '更新中'
                                : '${formatTime(spot.nightStart)} - ${formatTime(spot.nightEnd)}',
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
                        Icon(size: 15.0, Icons.sunny), // Add your desired icon
                        Text(
                            (spot.dayMin == null || spot.dayMax == null)
                                ? '更新中'
                                : '${parseInt(spot.dayMin)}円 - ${parseInt(spot.dayMax)}円',
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                            size: 15.0,
                            Icons.nightlight), // Add your desired icon
                        Text(
                            (spot.nightMin == null || spot.nightMax == null)
                                ? '更新中'
                                : '${parseInt(spot.nightMin)}円 - ${parseInt(spot.nightMax)}円',
                            style: TextStyle(fontSize: 12)),
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
