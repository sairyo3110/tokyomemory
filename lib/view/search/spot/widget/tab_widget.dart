import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/view/search/spot/widget/icon_tab.dart';
import 'package:mapapp/view/search/spot/widget/tab.dart';

class SpottabWidget extends StatelessWidget {
  final bool isMapView;

  SpottabWidget({required this.isMapView});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color:
          isMapView ? Colors.transparent : AppColors.primary, // マップ表示の場合は背景を透明に
      child: Row(
        children: [
          SizedBox(width: 10),
          SpotTextIconTab(
            text: '①',
            onTap: () {},
          ),
          // TODO 営業時刻がしっかりとフィルタリングできるようになったら追加
          //SizedBox(width: 10),
          //SpotTextTab(
          //  text: '営業中',
          //  onTap: () {},
          //),
          SizedBox(width: 10),
          SpotTextTab(
            text: 'カフェ',
            onTap: () {},
          ),
          SizedBox(width: 10),
          SpotTextTab(
            text: 'ホテル',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
