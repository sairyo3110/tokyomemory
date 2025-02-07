import 'package:flutter/material.dart';

class SpotDitealSubtitleText extends StatelessWidget {
  final String station;
  final String category;

  SpotDitealSubtitleText({
    required this.station,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        Text(
          station,
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
        Text(
          "/",
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
        Text(
          category,
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
