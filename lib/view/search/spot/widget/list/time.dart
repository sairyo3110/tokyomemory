import 'package:flutter/material.dart';
import 'package:mapapp/view/search/spot/widget/spot_icon_tab.dart';
import 'package:mapapp/utils.dart'; // utils.dartをインポート

class SpotTimeWidget extends StatelessWidget {
  final String minDayTime;
  final String maxDayTime;
  final String minNightTime;
  final String maxNightTime;

  SpotTimeWidget({
    required this.minDayTime,
    required this.maxDayTime,
    required this.minNightTime,
    required this.maxNightTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        SpotDetailTextIconTab(
          text: '営業時間',
          icon: Icons.schedule,
        ),
        SizedBox(width: 10), // アイコンとテキストの間にスペースを追加
        Text(
          '営業中',
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
          '${formatTime(minDayTime)}~${formatTime(maxDayTime)}',
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
          '${formatTime(minNightTime)}~${formatTime(maxNightTime)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
