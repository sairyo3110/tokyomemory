import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapapp/model/plan.dart';
import 'package:mapapp/repository/date_plan_controller.dart';
import 'package:mapapp/test/places_provider.dart';
import 'package:mapapp/test/rerated_model.dart';
import 'plan_detail_screenrealy.dart';

class PlanListScreen extends StatefulWidget {
  final int categoryId;

  PlanListScreen({required this.categoryId});

  @override
  _PlanListScreenState createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<PlanListScreen> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<DatePlan>> futurePlans;
  late Future<List<PlaceDetail>> futurePlaceDetails; // Add this line
  String searchTerm = "";
  double _appBarHeight = 40.0;
  Alignment _alignment = Alignment.centerLeft;
  double _fontSize = 20.0;

  @override
  void initState() {
    super.initState();
    futurePlans =
        DatePlanController().fetchDatePlansByCategory(widget.categoryId);

    futurePlans.then((plans) {
      // プランからすべてのユニークなスポットIDを抽出
      var spotIds = plans
          .map((plan) => [
                plan.mainSpotId,
                plan.lunchSpotId,
                plan.cafeSpotId,
                plan.subSpotId,
                plan.dinnerSpotId,
                plan.hotelSpotId
              ])
          .expand((x) => x)
          .toSet()
          .toList();
      futurePlaceDetails =
          PlacesProvider(context).fetchFilteredPlaceDetails(spotIds);
      PlacesProvider(context)
          .fetchFilteredPlaceDetails(spotIds)
          .then((placeDetails) {
        // デバッグコンソールに取得した場所の詳細を出力
        for (PlaceDetail place in placeDetails) {
          debugPrint('Place: ${place.imageUrl}, ID: ${place.placeId}');
        }
      }).catchError((error) {
        debugPrint('場所の詳細の取得に失敗しました: $error');
      });

      // ... その他のコード
    }).catchError((error) {
      debugPrint('プランの取得に失敗しました: $error');
    });
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _appBarHeight = max(50.0, 80.0 - offset); // スクロールに応じてAppBarの高さを変更
      _fontSize = max(20.0, 40.0 - offset); // スクロールに応じてフォントサイズを変更
      if (offset > 20.0) {
        // 20.0は適当な閾値、実際には適切な値を設定する必要があります
        _alignment = Alignment.center; // スクロールが一定量進んだらセンターに配置
      } else {
        _alignment = Alignment.centerLeft; // それ以外の場合は左寄せ
      }
    });
  }

  List<DatePlan> _filterPlans(List<DatePlan> plans, String searchTerm) {
    if (searchTerm.isEmpty) {
      return plans;
    }
    return plans
        .where((plan) =>
            plan.planName.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight), // AppBarの縦幅を100.0に設定
        child: AppBar(
          title: Container(
            padding: EdgeInsets.all(8.0), // 余白を追加
            alignment: _alignment, // alignmentを動的に設定
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.0), // 上に10.0の余白を追加
                Text(
                  'Date Plans',
                  style: TextStyle(
                    color: Color(0xFFF6E6DC),
                    fontSize: _fontSize, // 文字サイズを40.0に設定
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          elevation: 0, // 影を消す
        ),
      ),
      body: FutureBuilder<List<DatePlan>>(
        future: futurePlans,
        builder: (context, snapshotPlans) {
          if (snapshotPlans.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshotPlans.hasError || !snapshotPlans.hasData) {
            return Center(child: Text('Error or no data'));
          } else {
            return FutureBuilder<List<PlaceDetail>>(
              future: futurePlaceDetails,
              builder: (context, snapshotPlaceDetails) {
                if (snapshotPlaceDetails.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshotPlaceDetails.hasError ||
                    !snapshotPlaceDetails.hasData) {
                  return Center(child: Text('Error or no data'));
                } else {
                  List<DatePlan> plans =
                      _filterPlans(snapshotPlans.data!, searchTerm);
                  List<PlaceDetail> placeDetails = snapshotPlaceDetails.data!;

                  return GridView.builder(
                    padding: EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2列で表示
                      crossAxisSpacing: 10, // 水平スペース
                      mainAxisSpacing: 10, // 垂直スペース
                      childAspectRatio: 4 / 3, // カードのアスペクト比
                    ),
                    itemCount: plans.length,
                    itemBuilder: (BuildContext context, int index) {
                      var plan = plans[index];
                      var mainSpotImage = placeDetails
                          .firstWhere(
                            (detail) => detail.placeId == plan.mainSpotId,
                            orElse: () => PlaceDetail(),
                          )
                          .imageUrl;
                      var cafeSpotImage = placeDetails
                          .firstWhere(
                            (detail) => detail.placeId == plan.cafeSpotId,
                            orElse: () => PlaceDetail(),
                          )
                          .imageUrl;
                      return Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlanDetailScreen(
                                  plan: plans[index],
                                ),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly, // 画像間に均等なスペースを提供
                                children: <Widget>[
                                  if (mainSpotImage != null)
                                    Image.network(
                                      "https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${mainSpotImage}/1.png",
                                      height: 75,
                                      width: 87, // 画面幅の4分の1の幅
                                      fit: BoxFit.cover, // 画像を適切にフィットさせる
                                    ),
                                  if (cafeSpotImage != null)
                                    Image.network(
                                      "https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${cafeSpotImage}/1.png",
                                      height: 75,
                                      width: 87, // 画面幅の4分の1の幅
                                      fit: BoxFit.cover, // 画像を適切にフィットさせる
                                    ),
                                ],
                              ),
                              Text(plans[index].planName),
                              SizedBox(height: 10.0),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 7.0, vertical: 3.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF6E6DC),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  (plans[index].chategories ?? ''),
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
