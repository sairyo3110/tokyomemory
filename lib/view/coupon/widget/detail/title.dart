import 'package:flutter/material.dart';

class CouponDetailSpotTitle extends StatelessWidget {
  final String title;

  CouponDetailSpotTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
