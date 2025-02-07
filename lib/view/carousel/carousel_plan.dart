import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/plan/plan.dart';
import 'package:mapapp/view/carousel/constant/constants.dart';
import 'package:mapapp/view/carousel/widget/detail.dart';
import 'package:mapapp/view/carousel/widget/icon.dart';
import 'package:mapapp/view/carousel/widget/image_plan.dart';

class CarouselPlan extends StatelessWidget {
  final List<Plan> plans;

  CarouselPlan({Key? key, required this.plans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = Constants.screenHeight(context);
    final screenWidth = Constants.screenWidth(context);
    final bottomNavigationHeight = Constants.bottomNavigationHeight;
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    return Scaffold(
      body: Container(
        height: screenHeight - bottomNavigationHeight,
        width: screenWidth,
        child: PageView.builder(
          scrollDirection: Axis.vertical, // 縦方向のスライドを有効にする
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return Stack(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        CarouselPlanImage(
                            image:
                                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.mainSpotId}/1.png'),
                        CarouselPlanImage(
                            image:
                                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.cafeSpotId}/1.png'),
                        CarouselPlanImage(
                            image:
                                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.dinnerSpotId}/1.png'),
                        CarouselPlanImage(
                            image:
                                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.mainSpotId}/1.png'),
                      ],
                    ),
                    Column(
                      children: [
                        CarouselPlanImage(
                            image:
                                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.lunchSpotId}/1.png'),
                        CarouselPlanImage(
                            image:
                                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.subSpotId}/1.png'),
                        CarouselPlanImage(
                            image:
                                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.hotelSpotId}/1.png'),
                        CarouselPlanImage(
                            image:
                                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.lunchSpotId}/1.png'),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10, // 下からの位置
                  left: 20, // 左からの位置
                  child: CarouselDitailWidget(
                    text1: 'プラン',
                    text2: plan.categoryName ?? '',
                    title: plan.planName,
                    explanation: plan.planComment ?? '',
                    screenWidth: screenWidth,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 5,
                  child: CarouselIconWidget(
                    favoriteType: 'plan',
                    userId: userId ?? '',
                    favoriteId: plan.planId,
                    name: plan.planName,
                    plan: plan, // プラン情報を渡す
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
