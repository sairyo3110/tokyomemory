import 'package:flutter/material.dart';

class PlanDiteailTitleText extends StatelessWidget {
  final String text;

  PlanDiteailTitleText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
