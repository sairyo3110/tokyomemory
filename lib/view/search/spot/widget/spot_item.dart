import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/utils.dart';
import 'package:mapapp/view/common/favorite/spot_favorite_bottan.dart';
import 'package:mapapp/view/search/spot/spot_detail.dart';
import 'package:mapapp/view/search/spot/widget/list/image_widget.dart';
import 'package:mapapp/view/search/spot/widget/list/line.dart';
import 'package:mapapp/view/search/spot/widget/list/price.dart';
import 'package:mapapp/view/search/spot/widget/list/subtitle.dart';
import 'package:mapapp/view/search/spot/widget/list/time.dart';
import 'package:mapapp/view/search/spot/widget/list/title.dart';
import 'package:mapapp/view/search/spot/widget/list/walking.dart';

class SpotItem extends StatelessWidget {
  final Spot spot;
  final Alignment heartIconAlignment;
  final String userId; // ユーザーIDを追加

  SpotItem({
    required this.spot,
    required this.userId, // コンストラクタにユーザーIDを追加
    this.heartIconAlignment = Alignment.topRight, // デフォルトは右上
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 全体を左寄せ
              children: [
                SpotLine(),
                SizedBox(height: 10), // 行間を調整
                SpotTitleText(
                  text: spot.name ?? "",
                ),
                SizedBox(height: 10), // 行間を調整
                SpotDitealSubtitleText(
                  station: spot.city ?? "",
                  category: spot.subcategoryName ?? "",
                ),
                SizedBox(height: 10), // 行間を調整
                SpotListImageWidget(
                  image: [
                    'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.placeId}/1.png',
                    'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.placeId}/2.png',
                  ],
                ),
                SizedBox(height: 10), // 行間を調整
                SpotPriceWidget(
                  minDayBudget: formatTime(spot.dayMin ?? "0"),
                  maxDayBudget: spot.dayMax ?? "0",
                  minNightBudget: spot.nightMin ?? "0",
                  maxNightBudget: spot.nightMax ?? "0",
                ),
                SizedBox(height: 10), // テキストと右端のスペースを追加
                SpotTimeWidget(
                  minDayTime: formatTime(spot.dayStart ?? ""),
                  maxDayTime: formatTime(spot.dayEnd ?? ""),
                  minNightTime: formatTime(spot.nightStart ?? ""),
                  maxNightTime: formatTime(spot.nightEnd ?? ""),
                ),
                SizedBox(height: 20), // テキストと右端のスペースを追加
                SpotWalkingWidget(
                  station: spot.nearestStation ?? "",
                  minute: spot.walkingMinutes ?? 0,
                ),
                SizedBox(height: 20), // テキストと右端のスペースを追加
              ],
            ),
            Align(
              alignment: heartIconAlignment, // ハートアイコンの位置を指定
              child: Padding(
                padding: const EdgeInsets.all(20.0), // 余白を追加
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
