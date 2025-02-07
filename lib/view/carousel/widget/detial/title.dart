import 'package:flutter/material.dart';

class CarouselTitleText extends StatelessWidget {
  final String text;

  CarouselTitleText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
