import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/plan/plan_main.dart';
import 'package:mapapp/date/modeles/plan/plan.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/coupon/coupon_detail.dart';
import 'package:mapapp/view/search/plan/plan_detail.dart';
import 'package:mapapp/view/search/spot/widget/diteail/coupon.dart';
import 'package:mapapp/view/search/spot/widget/diteail/explanation.dart';
import 'package:mapapp/view/search/spot/widget/diteail/favorite_bottan.dart';
import 'package:mapapp/view/search/spot/widget/diteail/mapapp_open_botton.dart';
import 'package:mapapp/view/search/spot/widget/diteail/plan_title.dart';
import 'package:mapapp/view/search/spot/widget/diteail/price.dart';
import 'package:mapapp/view/search/spot/widget/diteail/plan_widget.dart';
import 'package:mapapp/view/search/spot/widget/diteail/share_bottan.dart';
import 'package:mapapp/view/search/spot/widget/diteail/spot_inf.dart';
import 'package:mapapp/view/search/spot/widget/diteail/spot_web.dart';
import 'package:mapapp/view/search/spot/widget/diteail/tab.dart';
import 'package:mapapp/view/search/spot/widget/diteail/time.dart';
import 'package:mapapp/view/search/spot/widget/diteail/title.dart';
import 'package:mapapp/view/search/spot/widget/diteail/walking.dart';
import 'package:mapapp/view/search/spot/widget/diteail/walking2.dart';
import 'package:mapapp/view/search/spot/widget/list/line.dart';
import 'package:provider/provider.dart';

class SpotDetail extends StatelessWidget {
  final Spot spot;

  SpotDetail({required this.spot});

  @override
  Widget build(BuildContext context) {
    List<Plan> relatedPlans =
        context.watch<PlanViewModel>().getPlansBySpotId(spot.placeId!);
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    return Scaffold(
      appBar: CustomAppBar(
        title: spot.name ?? 'No name',
        showBackButton: true,
      ),
      body: BaseScreen(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  child: PageView(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.placeId}/1.png',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, dynamic error) =>
                            Image.asset(
                          'images/noimage.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      CachedNetworkImage(
                        imageUrl:
                            'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.placeId}/2.png',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, dynamic error) =>
                            Image.asset(
                          'images/noimage.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 20),
                    SpotDitealTextTab(text: spot.city ?? 'No city'),
                    SizedBox(width: 10),
                    SpotDitealTextTab(
                        text: spot.subcategoryName ?? 'No category'),
                  ],
                ),
                SizedBox(height: 10),
                SpotDiteailTitleText(text: spot.name ?? 'No name'),
                SizedBox(height: 10),
                SpotWalkingDitealiWidget(
                  station: spot.nearestStation ?? 'No location',
                  minute: spot.walkingMinutes ?? 0,
                ),
                SizedBox(height: 20),
                SpotDiteailPriceWidget(
                  minDayBudget: spot.dayMin ?? '0',
                  maxDayBudget: spot.dayMax ?? '0',
                  minNightBudget: spot.nightMin ?? '0',
                  maxNightBudget: spot.nightMax ?? '0',
                ),
                SizedBox(height: 20),
                SpotDiteailExplanationText(
                  text: spot.description ?? 'No description',
                ),
                if (spot.cCouponId != null) ...[
                  SizedBox(height: 20),
                  SpotDiteailCoupon(
                    text: spot.cDescription ?? 'No coupon',
                    images:
                        'https://mymapapp.s3.ap-northeast-1.amazonaws.com/coupon/${spot.name}/1.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CouponDetail(
                            coupon: spot,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                SizedBox(height: 20),
                if (relatedPlans.isNotEmpty) ...[
                  SpotLine(),
                  SizedBox(height: 20),
                  SpotDitealPlanTitleText(
                    text: "プラン",
                  ),
                  SizedBox(height: 20),
                  SpotDiteailPlanWidget(
                    spots: relatedPlans
                        .map((plan) => {
                              'name': plan.planName,
                              'station': plan.categoryName ?? 'No category',
                              'image': plan.mainSpotId.toString(),
                            })
                        .toList(),
                    onSpotTap: (name) {
                      final selectedPlan = relatedPlans
                          .firstWhere((plan) => plan.planName == name);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlanDetail(plan: selectedPlan),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
                SpotLine(),
                SizedBox(height: 40),
                SpotDetailWidget(
                  icon: Icons.map,
                  text:
                      '${spot.prefecture ?? 'No city'}${spot.city ?? 'No city'} ${spot.chome ?? 'No location'}-${spot.banchi ?? 'No location'}-${spot.go ?? 'No location'}-${spot.buildingName ?? ''}',
                ),
                SizedBox(height: 10),
                OpenMapsButton(
                  placeName: spot.name ?? 'No name',
                  latitude: spot.paLatitude ?? 0, // 緯度
                  longitude: spot.paLongitude ?? 0, // 経度
                ),
                SizedBox(height: 40),
                // TODO 電話情報を後で追加する。
                //SpotDetailWidget(
                //  icon: Icons.phone,
                //  text: '00-0000-0000',
                //),
                //SizedBox(height: 40),
                //TODO　曜日データが入ったらSpotDetailTimeListWidgetに変更
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // 上部を揃える
                  children: [
                    SizedBox(width: 20),
                    Icon(
                      Icons.watch_later,
                      size: 18,
                      color: Colors.black,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // テキストを左揃え
                            children: [
                              SpotDetailTimeText(
                                text: '',
                                minDayTime: spot.dayStart ?? '',
                                maxDayTime: spot.dayEnd ?? '',
                                minNightTime: spot.nightStart ?? '',
                                maxNightTime: spot.nightEnd ?? '',
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Icon(
                      Icons.currency_yen,
                      size: 18,
                      color: Colors.black,
                    ),
                    SpotDiteailPriceWidget(
                      minDayBudget: spot.dayMin ?? '0',
                      maxDayBudget: spot.dayMax ?? '0',
                      minNightBudget: spot.nightMin ?? '0',
                      maxNightBudget: spot.nightMax ?? '0',
                    ),
                  ],
                ),
                SizedBox(height: 40),
                SpotWalkingDitealiWidget2(
                  station: spot.nearestStation ?? 'No location',
                  minute: spot.walkingMinutes ?? 0,
                ),
                SizedBox(height: 40),
                SpotDetailWebWidget(
                  icon: Icons.web,
                  text: '予約公式サイト',
                  url: spot.reservationSite ?? "",
                ),
                // TODO Googleのフォームが完成したら表示
                //SizedBox(height: 40),
                //SpotDetailWebWidget(
                //  icon: Icons.edit,
                //  text: '情報が間違っている場合はこちらから',
                //  url: "https://www.tokyotower.co.jp/",
                //),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpotDitealFavoriteWidget(
              favoriteType: 'spot',
              userId: userId ?? '',
              favoriteId: spot.placeId ?? 0,
            ),
            SizedBox(width: 30),
            SpotDitealShareWidget(
              favoriteType: 'spot',
              favoriteId: spot.placeId ?? 0,
              name: spot.name ?? "",
            ),
          ],
        ),
      ),
    );
  }
}
