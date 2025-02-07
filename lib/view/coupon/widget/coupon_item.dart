import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:mapapp/colors.dart';

class CouponItem extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String storeName;
  final String location;
  final VoidCallback onTap;
  final Alignment heartIconAlignment;

  CouponItem({
    required this.imageUrl,
    required this.description,
    required this.storeName,
    required this.location,
    required this.onTap,
    this.heartIconAlignment = Alignment.topRight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // 角に丸みをつける
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // 影の位置を調整
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 全体を左寄せ
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      right: 20,
                      left: 20,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          width: 110,
                          child: Text(
                            description,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 全体を左寄せ
                      children: [
                        Text(
                          storeName,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          location,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Dash(
                      direction: Axis.horizontal,
                      length: constraints.maxWidth - 40, // パディングを引いた幅を設定
                      dashLength: 12,
                      dashColor: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20, left: 55),
                    child: Container(
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30), // 角に丸みをつける
                        color: AppColors.primary,
                      ),
                      child: Center(
                        child: Text(
                          "特典を使用",
                          style: TextStyle(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
