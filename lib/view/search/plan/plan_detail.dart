import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/date/modeles/plan/plan.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/search/plan/widget/detail/explantaion.dart';
import 'package:mapapp/view/search/plan/widget/detail/info.dart';
import 'package:mapapp/view/search/plan/widget/detail/spot_widget.dart';
import 'package:mapapp/view/search/plan/widget/detail/title.dart';
import 'package:mapapp/view/search/spot/spot_detail.dart';
import 'package:mapapp/view/search/spot/widget/diteail/favorite_bottan.dart';
import 'package:mapapp/view/search/spot/widget/diteail/share_bottan.dart';

class PlanDetail extends StatelessWidget {
  final Plan plan;

  PlanDetail({required this.plan});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    return Scaffold(
      body: BaseScreen(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.width / 2.5,
              collapsedHeight: kToolbarHeight,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var top = constraints.biggest.height;
                  bool isCollapsed = top <=
                      kToolbarHeight + MediaQuery.of(context).padding.top;
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: isCollapsed
                        ? Text(plan.planName,
                            style: TextStyle(color: Colors.white))
                        : null,
                    background: Row(
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.mainSpotId}/1.png',
                            fit: BoxFit.cover, // 画像を引き伸ばす
                            errorWidget: (context, url, dynamic error) =>
                                Image.asset(
                              'images/noimage.png', // 代替画像のパス
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.subSpotId}/1.png',
                            fit: BoxFit.cover, // 画像を引き伸ばす
                            errorWidget: (context, url, dynamic error) =>
                                Image.asset(
                              'images/noimage.png', // 代替画像のパス
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 40),
                  Center(
                    child: PlanDiteailTitleText(text: plan.planName),
                  ),
                  PlanDiteailInfoText(
                    category: plan.categoryName ?? 'カテゴリー',
                    city: plan.chategories ?? 'カテゴリー',
                  ),
                  SizedBox(height: 20),
                  PlanDiteailExplantaionText(
                    text: plan.planComment ?? '説明',
                  ),
                  SizedBox(height: 40),
                  PlanSpotWidget(
                    itemList: [
                      {
                        'imageUrl':
                            'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.mainSpotId}/1.png',
                        'time': plan.mainTime ?? '10:00',
                        'title': plan.mainMemo,
                        'spot': plan.mainSpot?.name ?? '場所の名前',
                        'onTap': () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpotDetail(spot: plan.mainSpot!),
                            ),
                          );
                        },
                      },
                      {
                        'imageUrl':
                            'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.lunchSpotId}/1.png',
                        'time': plan.lunchTime ?? '12:00',
                        'title': plan.lunchMemo,
                        'spot': plan.lunchSpot?.name ?? '場所の名前',
                        'onTap': () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpotDetail(spot: plan.lunchSpot!),
                            ),
                          );
                        },
                      },
                      {
                        'imageUrl':
                            'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.cafeSpotId}/1.png',
                        'time': plan.cafeTime ?? '15:00',
                        'title': plan.cafeMemo,
                        'spot': plan.cafeSpot?.name ?? '場所の名前',
                        'onTap': () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpotDetail(spot: plan.cafeSpot!),
                            ),
                          );
                        },
                      },
                      {
                        'imageUrl':
                            'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.subSpotId}/1.png',
                        'time': plan.subTime ?? '17:00',
                        'title': plan.subMemo,
                        'spot': plan.subSpot?.name ?? '場所の名前',
                        'onTap': () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpotDetail(spot: plan.subSpot!),
                            ),
                          );
                        },
                      },
                      {
                        'imageUrl':
                            'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.dinnerSpotId}/1.png',
                        'time': plan.dinnerTime ?? '19:00',
                        'title': plan.dinnerMemo,
                        'spot': plan.dinnerSpot?.name ?? '場所の名前',
                        'onTap': () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpotDetail(spot: plan.dinnerSpot!),
                            ),
                          );
                        },
                      },
                      {
                        'imageUrl':
                            'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.hotelSpotId}/1.png',
                        'time': plan.hotelTime ?? '21:00',
                        'title': plan.hotelMemo,
                        'spot': plan.hotelSpot?.name ?? '場所の名前',
                        'onTap': () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpotDetail(spot: plan.hotelSpot!),
                            ),
                          );
                        },
                      },
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpotDitealFavoriteWidget(
              favoriteType: 'plan',
              userId: userId ?? '',
              favoriteId: plan.planId,
            ),
            SizedBox(width: 30),
            SpotDitealShareWidget(
              favoriteType: 'plan',
              favoriteId: plan.planId,
              name: plan.planName,
            ),
          ],
        ),
      ),
    );
  }
}
