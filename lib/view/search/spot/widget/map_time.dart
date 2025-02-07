import 'package:flutter/material.dart';
import 'package:mapapp/view/search/spot/widget/spot_icon_tab.dart';

class SpotMapTimeWidget extends StatelessWidget {
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
      ],
    );
  }
}
