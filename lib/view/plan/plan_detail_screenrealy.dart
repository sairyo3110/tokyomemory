import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';
import 'package:mapapp/model/plan.dart';
import 'package:mapapp/provider/places_provider.dart';
import 'package:mapapp/model/rerated_model.dart';
import 'package:mapapp/view/spot/spot_detail_screen.dart';
import 'package:share/share.dart';

class PlanDetailScreen extends StatefulWidget {
  final DatePlan plan;

  PlanDetailScreen({required this.plan});

  @override
  _PlanDetailScreenState createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  Future<List<PlaceDetail>>? futurePlaceDetails;

  bool isAndroid = !kIsWeb && Platform.isAndroid; // WebではないかつAndroidの場合にtrue
  bool isIOS = !kIsWeb && Platform.isIOS; // WebではないかつiOSの場合にtrue

  @override
  void initState() {
    super.initState();
    PlacesProvider provider = PlacesProvider();
    List<int> spotIds = [
      widget.plan.mainSpotId,
      widget.plan.lunchSpotId,
      widget.plan.subSpotId,
      widget.plan.cafeSpotId,
      widget.plan.dinnerSpotId,
      widget.plan.hotelSpotId,
    ].whereType<int>().toList();

    futurePlaceDetails = provider.fetchFilteredPlaceDetails(spotIds);

    futurePlaceDetails?.then((placeDetails) {
      // デバックコンソールにPlaceDetailの値を出力
      for (var placeDetail in placeDetails) {
        debugPrint('Place ID: ${placeDetail.placeId}');
        debugPrint('Name: ${placeDetail.name}');
        debugPrint('Address: ${placeDetail.address}');
        debugPrint('Description: ${placeDetail.description}');
        // 他のプロパティも必要に応じて出力
      }
    }).catchError((error) {
      debugPrint('エラーが発生しました: $error');
    });
  }

  void _sharePage(BuildContext context) {
    final String deepLinkUrl = 'mapapp://plan/${widget.plan.planId}';
    const String AndroidLinkUrl =
        'https://play.google.com/store/apps/details?id=tokyomemory.mapapp0918&pli=1';
    final String IOSLinkUrl =
        'https://apps.apple.com/jp/app/tokyo-memory/id6466747873';
    if (isAndroid) {
      Share.share(
          'このデートプランで今度デートしてみない？\n\n${widget.plan.planName}\n\n▼ここから見てみて！\n${deepLinkUrl}\n\nアプリをダウンロードしていない場合はここから▼\n${AndroidLinkUrl}');
    }
    if (isIOS) {
      Share.share(
          'このデートプランで今度デートしてみない？\n\n${widget.plan.planName}\n\n▼ここから見てみて！\n${deepLinkUrl}\n\nアプリをダウンロードしていない場合はここから▼\n${IOSLinkUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaceDetail>>(
      future: futurePlaceDetails, // nullチェックを追加
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<PlaceDetail> placeDetails = snapshot.data!;
            // UI構築ロジックをここに実装
            // 例: placeDetailsから情報を取得して表示
            return buildScreenContent(placeDetails);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
        }
        // ...データを待っている間の処理
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildScreenContent(List<PlaceDetail> placeDetails) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true, // This will pin the app bar
            expandedHeight:
                200.0, // The expanded height when scrolled to the top
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      "https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${placeDetails[0].imageUrl}/1.png",
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: top > 80
                          ? ElevatedButton.icon(
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
                                  borderRadius: BorderRadius.circular(
                                      20), // 角の丸みを20の半径で設定
                                ),
                              ),
                            )
                          : SizedBox
                              .shrink(), // SliverAppBarが縮小されたときにボタンを非表示にする
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: top > 80
                          ? Text(
                              widget.plan.planName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox
                              .shrink(), // SliverAppBarが縮小されたときにタイトルを非表示にする
                    ),
                  ],
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0), // 16.0は適当な値なので、望む余白に調整してください。
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      activitySection(Icons.star, 'メイン',
                          placeDetails[0].name ?? "未定義", placeDetails[0]),
                      activitySection(Icons.fastfood, 'ランチ',
                          placeDetails[1].name ?? "未定義", placeDetails[1]),
                      activitySection(Icons.place, 'サブ',
                          placeDetails[2].name ?? "未定義", placeDetails[2]),
                      activitySection(Icons.local_cafe, 'カフェ',
                          placeDetails[3].name ?? "未定義", placeDetails[3]),
                      activitySection(Icons.restaurant, 'ディナー',
                          placeDetails[4].name ?? "未定義", placeDetails[4]),
                      activitySection(Icons.hotel, 'ホテル',
                          placeDetails[5].name ?? "未定義", placeDetails[5]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget activitySection(
      IconData icon, String title, String activityName, PlaceDetail? place) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              child: Icon(icon, size: 16),
              backgroundColor: Colors.transparent, // 背景色を透明に設定
              foregroundColor: Color(0xFFF6E6DC),
              radius: 16.0,
            ),
            SizedBox(width: 8),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(activityName, style: TextStyle(fontSize: 16)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('住所: ' + (place?.address ?? "未定義")),
                  Text('詳細: ' + (place?.description ?? "未定義")),
                ],
              ),
              onTap: () {
                if (place != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SpotDetailScreen(parentContext: context, spot: place),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
