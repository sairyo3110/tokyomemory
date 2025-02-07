import 'package:flutter/material.dart';

class SpotDiteailExplanationText extends StatelessWidget {
  final String text;

  SpotDiteailExplanationText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0), // Paddingを追加
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
          ),
          softWrap: true, // テキストの折り返しを許可
        ),
      ),
    );
  }
}
