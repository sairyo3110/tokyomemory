import 'package:flutter/material.dart';

class SpotDetailTimeText extends StatelessWidget {
  final String text;
  final String minDayTime;
  final String maxDayTime;
  final String minNightTime;
  final String maxNightTime;

  SpotDetailTimeText({
    required this.text,
    required this.minDayTime,
    required this.maxDayTime,
    required this.minNightTime,
    required this.maxNightTime,
  });

  String removeTrailingZeros(String time) {
    if (time.contains('.00')) {
      return time.replaceAll('.00', '');
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        Icon(
          Icons.sunny,
          size: 12,
          color: Colors.black,
        ),
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        Text(
          '${removeTrailingZeros(minDayTime)}~${removeTrailingZeros(maxDayTime)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        Icon(
          Icons.nightlight_round,
          size: 12,
          color: Colors.black,
        ),
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        Text(
          '${removeTrailingZeros(minNightTime)}~${removeTrailingZeros(maxNightTime)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
