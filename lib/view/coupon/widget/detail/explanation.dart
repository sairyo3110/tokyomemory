import 'package:flutter/material.dart';

class CouponDetailExplanation extends StatelessWidget {
  final String explanation;

  CouponDetailExplanation({required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Text(
            explanation,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
