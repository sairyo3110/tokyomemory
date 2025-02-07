import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/plan/plan.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/utils.dart';
import 'package:mapapp/view/common/favorite/plan_favorite_bottan.dart';
import 'package:mapapp/view/common/favorite/spot_favorite_bottan.dart';
import 'package:mapapp/view/search/plan/plan_detail.dart';
import 'package:mapapp/view/search/spot/spot_detail.dart';

class CarouselIconWidget extends StatelessWidget {
  final String favoriteType;
  final String userId;
  final int favoriteId;
  final String name;
  final Spot? spot; // スポット情報
  final Plan? plan; // プラン情報

  CarouselIconWidget({
    required this.favoriteType,
    required this.userId,
    required this.favoriteId,
    required this.name,
    this.spot,
    this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (favoriteType == 'spot')
          FavoriteIconWidget(
            userId: userId,
            placeId: favoriteId,
            isFavorite: null,
          )
        else
          PlanFavoriteIconWidget(
            userId: userId,
            placeId: favoriteId,
            type: favoriteType,
          ),
        IconButton(
          onPressed: () {
            if (favoriteType == 'spot' && spot != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpotDetail(spot: spot!),
                ),
              );
            } else if (favoriteType == 'plan' && plan != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlanDetail(plan: plan!),
                ),
              );
            }
          },
          icon: Icon(
            Icons.info,
            color: Colors.white,
            size: 37,
          ),
        ),
        IconButton(
          onPressed: () {
            if (favoriteType == 'spot') {
              shareContent(
                context: context,
                placeId: favoriteId.toString(),
                name: name,
              );
            } else {
              sharePlan(
                context: context,
                planId: favoriteId.toString(),
                name: name,
              );
            }
          },
          icon: Icon(
            Icons.reply,
            color: Colors.white,
            size: 37,
          ),
        ),
        SizedBox(height: 20),
        //TODO DateAIを追加
        //GestureDetector(
        //  onTap: () {
        //  },
        //  child: Image.asset(
        //    'images/dateai.png', // Replace with the actual path to your image
        //    fit: BoxFit.cover,
        //  ),
        //),
      ],
    );
  }
}
