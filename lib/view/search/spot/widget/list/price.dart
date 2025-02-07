import 'package:flutter/material.dart';
import 'package:mapapp/view/common/price_format.dart';
import 'package:mapapp/view/search/spot/widget/spot_icon_tab.dart';

class SpotPriceWidget extends StatelessWidget {
  final String minDayBudget;
  final String maxDayBudget;
  final String minNightBudget;
  final String maxNightBudget;

  SpotPriceWidget({
    required this.minDayBudget,
    required this.maxDayBudget,
    required this.minNightBudget,
    required this.maxNightBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        SpotDetailTextIconTab(
          text: '予算',
          icon: Icons.currency_yen,
        ),
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        Icon(
          Icons.sunny,
          size: 12,
          color: Colors.black,
        ),
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        Text(
          '${formatPrice(minDayBudget)}円~${formatPrice(maxDayBudget)}円',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        Icon(
          Icons.nightlight_round,
          size: 12,
          color: Colors.black,
        ),
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        Text(
          '${formatPrice(minNightBudget)}円~${formatPrice(maxNightBudget)}円',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
