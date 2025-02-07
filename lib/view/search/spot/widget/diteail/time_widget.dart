import 'package:flutter/material.dart';
import 'package:mapapp/view/search/spot/widget/diteail/time.dart';

class SpotDetailTimeListWidget extends StatelessWidget {
  final List<Map<String, String>> timeDetails;

  SpotDetailTimeListWidget({required this.timeDetails});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // 上部を揃える
      children: [
        SizedBox(width: 20),
        Icon(
          Icons.watch_later,
          size: 18,
          color: Colors.black,
        ),
        SizedBox(width: 20),
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // テキストを左揃え
              children: timeDetails.map((detail) {
                return SpotDetailTimeText(
                  text: detail['text']!,
                  minDayTime: detail['minDayTime']!,
                  maxDayTime: detail['maxDayTime']!,
                  minNightTime: detail['minNightTime']!,
                  maxNightTime: detail['maxNightTime']!,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
