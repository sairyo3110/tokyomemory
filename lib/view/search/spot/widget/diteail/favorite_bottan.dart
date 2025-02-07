import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/view/common/favorite/plan_favorite_bottan.dart';
import 'package:mapapp/view/common/favorite/spot_favorite_bottan.dart';

class SpotDitealFavoriteWidget extends StatelessWidget {
  final String favoriteType;
  final String userId;
  final int favoriteId;

  SpotDitealFavoriteWidget({
    required this.favoriteType,
    required this.userId,
    required this.favoriteId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Row(
              children: [
                SizedBox(width: 20),
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
                SizedBox(width: 10),
                Text(
                  'お気に入り',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
