import 'package:flutter/material.dart';

class SpotDiteailPriceWidget extends StatelessWidget {
  final String minDayBudget;
  final String maxDayBudget;
  final String minNightBudget;
  final String maxNightBudget;

  SpotDiteailPriceWidget({
    required this.minDayBudget,
    required this.maxDayBudget,
    required this.minNightBudget,
    required this.maxNightBudget,
  });

  String removeTrailingZeros(String price) {
    if (price.endsWith('.00')) {
      return price.substring(0, price.length - 3);
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20), // アイコンとテキストの間にスペースを追加
        Icon(
          Icons.sunny,
          size: 12,
          color: Colors.black,
        ),
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        Text(
          '${removeTrailingZeros(minDayBudget)}円~${removeTrailingZeros(maxDayBudget)}円',
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
          '${removeTrailingZeros(minNightBudget)}円~${removeTrailingZeros(maxNightBudget)}円',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
