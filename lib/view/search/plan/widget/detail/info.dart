import 'package:flutter/material.dart';

class PlanDiteailInfoText extends StatelessWidget {
  final String category;
  final String city;

  PlanDiteailInfoText({required this.category, required this.city});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // BEGIN: Center alignment
      children: [
        Text(
          category,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        //TODO プランカテゴリーが埋まったら実装
        //Text(
        //  "/",
        //  style: TextStyle(
        //    color: Colors.grey,
        //    fontSize: 14,
        //  ),
        //),
        //Text(
        //  city,
        //  style: TextStyle(
        //    color: Colors.grey,
        //    fontSize: 14,
        //  ),
        //),
      ],
    ); // END: Center alignment
  }
}
