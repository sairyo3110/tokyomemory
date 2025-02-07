import 'package:flutter/material.dart';

class SpotTitleText extends StatelessWidget {
  final String text;

  SpotTitleText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        Align(
          widthFactor: 1.0,
          alignment: Alignment.centerLeft,
          child: Container(
            width: 250,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
