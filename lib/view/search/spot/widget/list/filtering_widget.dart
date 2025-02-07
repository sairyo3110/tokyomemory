import 'package:flutter/material.dart';

class SpotListFilteringWidget extends StatelessWidget {
  final int count;

  SpotListFilteringWidget({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            '$count件',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Spacer(), // 余白を確保して右寄せ
          Row(
            children: [
              Icon(Icons.sort),
              Text(
                '現在地から近い順',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
