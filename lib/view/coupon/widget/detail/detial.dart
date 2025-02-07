import 'package:flutter/material.dart';

class CouponDetailText extends StatelessWidget {
  final String detial;

  CouponDetailText({required this.detial});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Text(
            detial,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
