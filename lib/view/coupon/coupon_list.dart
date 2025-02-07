import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/coupon/coupon_detail.dart';
import 'package:mapapp/view/coupon/widget/coupon_item.dart';

class CouponList extends StatelessWidget {
  final List<Spot> coupons;

  CouponList({required this.coupons});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: coupons.length,
          itemBuilder: (context, index) {
            final coupon = coupons[index];
            return CouponItem(
              imageUrl:
                  "https://mymapapp.s3.ap-northeast-1.amazonaws.com/coupon/${coupon.name}/1.png", // ここに適切な画像URLを設定
              description: coupon.cDescription ?? "",
              storeName: coupon.name ?? "", // Spotモデルの適切なフィールドを使用
              location:
                  '${coupon.nearestStation}より徒歩${coupon.walkingMinutes}分', // 必要に応じて修正
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CouponDetail(coupon: coupon)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
