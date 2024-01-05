import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';

class PageViewCard extends StatelessWidget {
  final List<PlaceDetail> spots;
  final String? userId;
  final PageController pageController;
  final Function(int) onPageChanged;

  const PageViewCard({
    Key? key,
    required this.spots,
    required this.userId,
    required this.pageController,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: spots.length,
      itemBuilder: (_, index) {
        final spot = spots[index];
        bool shouldDisplayRow =
            double.tryParse(spot.dayMin ?? '0')?.toInt() != 0 ||
                double.tryParse(spot.dayMax ?? '0')?.toInt() != 0 ||
                double.tryParse(spot.nightMin ?? '0')?.toInt() != 0 ||
                double.tryParse(spot.nightMax ?? '0')?.toInt() != 0;
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SpotDetailScreen(parentContext: context, spot: spot),
                  ),
                );
              },
              child: Padding(
                  padding: EdgeInsets.only(left: 30), // 左側にのみパディングを適用
                  child: Row(children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.3, // 画像の幅を画面幅の30%に設定
                      height: MediaQuery.of(context).size.height *
                          0.14, // 画像の高さを画面高の20%に設定
                      child: (spot.imageUrl?.isEmpty ?? true)
                          ? Image(
                              image: AssetImage('images/noimage.png'),
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.imageUrl}/1.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0), // テキストセクションのパディング
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
                                      overflow: TextOverflow
                                          .ellipsis, // タイトルが長い場合は省略記号を表示
                                    ),
                                  ),
                                  FavoriteIconWidget(
                                    userId: userId!,
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
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        (spot.pcsName ?? '更新中'),
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
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Text(
                                          'クーポン',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ),
                                  ]),
                                  SizedBox(height: 10),
                                  Text(
                                    (spot.city ?? '') +
                                        '/' +
                                        (spot.nearestStation ?? ''),
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
                                                  double.tryParse(spot.dayMax ??
                                                              '0')
                                                          ?.toInt() ==
                                                      0)
                                              ? '${double.tryParse(spot.nightMin ?? '0')?.toInt()}円 - ${double.tryParse(spot.nightMax ?? '0')?.toInt()}円'
                                              : '${double.tryParse(spot.dayMin ?? '0')?.toInt()}円 - ${double.tryParse(spot.dayMax ?? '0')?.toInt()}円',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ]),
                      ),
                    )
                  ])),
            ),
          ),
        );
      },
    );
  }
}
