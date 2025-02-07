import 'package:flutter/material.dart';
import 'package:mapapp/view/search/plan/widget/detail/spot_item.dart';

class PlanSpotWidget extends StatelessWidget {
  final List<Map<String, dynamic>> itemList;

  PlanSpotWidget({required this.itemList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700, // 適切な高さを設定
      child: ListView(
        physics: NeverScrollableScrollPhysics(), // スクロールを無効化
        children: itemList.map((item) {
          return PlanSpotItem(
            imageUrl: item['imageUrl'],
            time: item['time'],
            title: item['title'],
            spot: item['spot'],
            onTap: item['onTap'],
          );
        }).toList(),
      ),
    );
  }
}
