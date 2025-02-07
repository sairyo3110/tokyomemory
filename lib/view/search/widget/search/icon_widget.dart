import 'package:flutter/material.dart';
import 'package:mapapp/view/common/bottomnavigation.dart';
import 'package:mapapp/view/search/plan/plan_main.dart';
import 'package:mapapp/view/search/spot/spot_main.dart';
import 'package:mapapp/view/search/widget/search/icon.dart';

class SearchIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SearchIcon(
          imagePath: 'images/tomap.png',
          text: 'マップ',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SpotScreen(initialMapView: true)),
            );
          },
        ),
        SearchIcon(
          imagePath: 'images/plan.png',
          text: 'プラン',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlanMain()),
            );
          },
        ),
        SearchIcon(
          imagePath: 'images/coupon.png',
          text: 'クーポン',
          onTap: () {
            NavigationProvider.of(context).selectPage(3);
          },
        ),
        //SearchIcon(
        //  imagePath: 'images/category.png',
        //  text: 'カテゴリー',
        //  onTap: () {
        //    Navigator.push(
        //      context,
        //      MaterialPageRoute(builder: (context) => CategoryhScreen()),
        //    );
        //  },
        //),
      ],
    );
  }
}
