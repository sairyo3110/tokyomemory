import 'package:flutter/material.dart';

class SpotWalkingDitealiWidget2 extends StatelessWidget {
  final String station;
  final int minute;

  SpotWalkingDitealiWidget2({
    required this.station,
    required this.minute,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20), // アイコンとテキストの間にスペースを追加
        Icon(
          Icons.directions_walk,
          size: 18,
          color: Colors.black,
        ),
        SizedBox(width: 20), // アイコンとテキストの間にスペースを追加
        Text(
          '$stationから徒歩$minute分',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
