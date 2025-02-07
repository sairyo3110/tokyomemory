import 'package:flutter/material.dart';

class CarouselExplanationText extends StatelessWidget {
  final String text;

  CarouselExplanationText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
    );
  }
}
