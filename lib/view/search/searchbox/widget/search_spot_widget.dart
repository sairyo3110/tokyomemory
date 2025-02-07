import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'search_spot.dart'; // SearchSpotウィジェットをインポート

class SearchSpotWidget extends StatelessWidget {
  final List<Spot> spots;
  final Function(int) onSpotTap;

  SearchSpotWidget({required this.spots, required this.onSpotTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // スクロールを無効にする
      itemCount: spots.length,
      itemBuilder: (context, index) {
        final spot = spots[index];
        return Column(
          children: [
            SearchSpot(
              name: spot.name ?? '名前がありません', // デフォルト値を設定
              station: spot.nearestStation ?? '駅名がありません', // デフォルト値を設定
              category: spot.subcategoryName ?? "", // デフォルト値を設定
              image:
                  'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.placeId}/1.png', // デフォルト値を設定
              onTap: () => onSpotTap(index),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
