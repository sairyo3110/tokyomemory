import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/view/common/favorite/spot_favorite_bottan.dart';
import 'package:mapapp/view/search/spot/spot_detail.dart';
import 'package:mapapp/view/search/spot/widget/list/subtitle.dart';
import 'package:mapapp/view/search/spot/widget/list/title.dart';

class SpotMapItem extends StatelessWidget {
  final Spot spot;
  final String userId; // ユーザーIDを追加
  final Alignment heartIconAlignment;

  SpotMapItem({
    required this.spot,
    required this.userId, // コンストラクタにユーザーIDを追加
    this.heartIconAlignment = Alignment.topRight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SpotDetail(spot: spot)),
        );
      },
      child: Container(
        color: Colors.white,
        height: 70,
        width: MediaQuery.of(context).size.width - 20,
        child: Stack(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 全体を左寄せ
                  children: [
                    SizedBox(height: 10), // 行間を調整
                    SpotTitleText(
                      text: spot.name ?? 'No name',
                    ),
                    SpotDitealSubtitleText(
                      station: spot.nearestStation ?? 'No location',
                      category: spot.subcategoryName ?? 'No category',
                    ),
                    SizedBox(height: 10), // 行間を調整
                  ],
                ),
                //TODO 営業時間の表示ができるようになったら表示
                //SpotMapTimeWidget(),
              ],
            ),
            Align(
              alignment: heartIconAlignment, // ハートアイコンの位置を指定
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, right: 20), // 余白を追加
                child: FavoriteIconWidget(
                  userId: userId,
                  placeId:
                      spot.placeId ?? 0, // 修正: favoriteIdではなくspot.placeIdを使用
                  isFavorite: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
