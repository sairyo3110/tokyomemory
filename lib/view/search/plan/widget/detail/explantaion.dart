import 'package:flutter/material.dart';

class PlanDiteailExplantaionText extends StatelessWidget {
  final String text;

  PlanDiteailExplantaionText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
        ),
        textAlign: TextAlign.center, // テキストをセンター揃え
      ),
    );
  }
}
