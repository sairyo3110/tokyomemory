import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/model/clickinfo.dart';
import 'package:mapapp/repository/clickInfo_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class MederuPRpages extends StatelessWidget {
  final ClickInfoController _clickInfoController =
      ClickInfoController(); // 新しいコード

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 10), // 上部の余白を追加
          Center(
            child: Text(
              'Mederu✖️Tokyo Memory \nスペシャルプラン',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 20),
          Container(
            width: 350,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'images/mederu.jpg',
                width: 325,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Tokyo Memory限定プランで30分写真取り放題！ \n撮影データ全てお渡し+チェキ2枚も無料！',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 15),
          Text(
            '※『その他備考』に必ず"Tokyo Memoryコラボプラン"と記載ください。',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Divider(
            color: Colors.grey, // 線の色を指定
            thickness: 0.5, // 線の厚さを指定
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '世田谷区北沢2丁目36-14 ガーデンテラス \n下北沢c区画',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time),
                  SizedBox(width: 8),
                  Text('12:00〜21:00'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.directions_transit),
                  SizedBox(width: 8),
                  Text('下北沢駅　徒歩4分'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.attach_money),
                  SizedBox(width: 8),
                  Text('¥10,000'),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '魅力ポイント',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('フォトジェニックな空間で高クオリティな写真を撮影できるセルフフォトスタジオ。2人の思い出作りにぴったり◎'),
              // ... 他のコードは変更なし
              ElevatedButton.icon(
                onPressed: () {
                  launch(
                      'https://www.google.com/maps/search/?api=1&query=35.663740,139.667730');
                },
                icon: Icon(Icons.map),
                label: Text('マップ'),
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey, // 線の色を指定
                thickness: 0.5, // 線の厚さを指定
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Save the click info
                    final String? userId = await getCurrentUserId(); // 新しいコード

                    if (userId != null) {
                      // 新しいコード
                      final ClickInfo clickInfo = ClickInfo(
                        // 新しいコード
                        spotId: 219999, // 任意のスポットIDを指定します  // 新しいコード
                        userId: userId, // 新しいコード
                        clickedAt: DateTime.now(), // 新しいコード
                      ); // 新しいコード
                      await _clickInfoController
                          .saveClickInfo(clickInfo); // 新しいコード
                    } else {
                      // 新しいコード
                      print(
                          "Error: Unable to fetch user ID from Cognito"); // 新しいコード
                    } // 新しいコード

                    launch(
                        'https://coubic.com/mederustduio/437478#pageContent');
                  },
                  icon: Icon(Icons.search),
                  label: Text('詳細はこちら'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 137, 183, 85), // 薄い赤色
                    onPrimary: Colors.white, // テキストの色
                    minimumSize: Size(200, 50), // ボタンのサイズ
                    textStyle: TextStyle(fontSize: 20), // テキストのサイズ
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 角の丸み
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ]),
      ),
    ));
  }

  Future<String?> getCurrentUserId() async {
    try {
      var currentUser =
          await Amplify.Auth.getCurrentUser(); // Amplifyをインポートする必要があります
      return currentUser.userId;
    } on AuthException catch (e) {
      // AuthExceptionをインポートする必要があります
      print(e);
      return null;
    }
  }
}
