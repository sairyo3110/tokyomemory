import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';

class SpotCard extends StatelessWidget {
  final PlaceDetail spot;
  final String userId;
  final List<PlaceCategorySub> categorySubs = [];

  SpotCard({Key? key, required this.spot, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool shouldDisplayRow = double.tryParse(spot.dayMin ?? '0')?.toInt() != 0 ||
        double.tryParse(spot.dayMax ?? '0')?.toInt() != 0 ||
        double.tryParse(spot.nightMin ?? '0')?.toInt() != 0 ||
        double.tryParse(spot.nightMax ?? '0')?.toInt() != 0;
    String categoryName = categorySubs
        .firstWhere(
            (categorySub) => categorySub.categoryId == spot.subcategoryId,
            orElse: () =>
                PlaceCategorySub(categoryId: 0, name: '', parentCategoryId: 0))
        .name;
    return Card(
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          children: <Widget>[
            // スポット画像
            SizedBox(
              width: 140.0,
              height: 140.0,
              child: Image.network(
                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.imageUrl}/1.png',
                fit: BoxFit.cover,
              ),
            ),
            // スポット詳細
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.0), // テキストセクションのパディング
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              spot.name ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // タイトルが長い場合は省略記号を表示
                            ),
                          ),
                          FavoriteIconWidget(
                            userId: userId,
                            placeId: spot.placeId ?? 0, // 実際の場所IDを設定する
                            isFavorite: false, // お気に入り状態を設定する
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFF6E6DC),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                categoryName,
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 10),
                            if ((spot.cCouponId ?? 0) != 0)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  'クーポン',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ),
                          ]),
                          SizedBox(height: 10),
                          Text(
                            '${spot.city}/${spot.nearestStation}',
                            style: TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                  size: 15.0,
                                  Icons
                                      .directions_walk), // Add your desired icon
                              Text(
                                ('${spot.nearestStation}より ${spot.walkingMinutes}分'),
                                style: TextStyle(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          if (shouldDisplayRow)
                            Row(
                              children: [
                                Icon(
                                    size: 15.0,
                                    Icons
                                        .currency_yen), // Add your desired icon
                                Text(
                                  (double.tryParse(spot.dayMin ?? '0')
                                                  ?.toInt() ==
                                              0 &&
                                          double.tryParse(spot.dayMax ?? '0')
                                                  ?.toInt() ==
                                              0)
                                      ? '${double.tryParse(spot.nightMin ?? '0')?.toInt()}円 - ${double.tryParse(spot.nightMax ?? '0')?.toInt()}円'
                                      : '${double.tryParse(spot.dayMin ?? '0')?.toInt()}円 - ${double.tryParse(spot.dayMax ?? '0')?.toInt()}円',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
