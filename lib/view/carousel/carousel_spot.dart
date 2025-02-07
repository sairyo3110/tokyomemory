import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/view/carousel/constant/constants.dart';
import 'package:mapapp/view/carousel/widget/detail.dart';
import 'package:mapapp/view/carousel/widget/icon.dart';
import 'package:mapapp/view/carousel/widget/image_spot.dart';

class CarouselSpot extends StatelessWidget {
  final List<Spot> spots;

  CarouselSpot({Key? key, required this.spots}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final screenWidth = Constants.screenWidth(context);
    return Scaffold(
      body: Container(
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: spots.length,
          itemBuilder: (context, index) {
            final spot = spots[index];
            return Stack(
              children: [
                Column(
                  children: [
                    CarouselSpotImage(
                      image: spot.placeId ?? 0,
                      num: 1,
                    ),
                    CarouselSpotImage(
                      image: spot.placeId ?? 0,
                      num: 2,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10, // 下からの位置
                  left: 20, // 左からの位置
                  child: CarouselDitailWidget(
                    text1: spot.cCouponId != null ? '限定特典' : '',
                    text2: spot.city ?? 'Unknown location',
                    title: spot.name ?? 'No name',
                    explanation: spot.description ?? 'No description',
                    screenWidth: screenWidth,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 5,
                  child: CarouselIconWidget(
                    favoriteType: 'spot',
                    userId: userId ?? '',
                    favoriteId: spot.placeId ?? 0,
                    name: spot.name ?? 'No name',
                    spot: spot, // スポット情報を渡す
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
