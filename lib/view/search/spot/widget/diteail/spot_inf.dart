import 'package:flutter/material.dart';

class SpotDetailWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  SpotDetailWidget({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20), // 左側のスペース
        Icon(
          icon,
          size: 18,
          color: Colors.black,
        ),
        SizedBox(width: 20), // アイコンとテキストの間にスペースを追加
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
            softWrap: true, // テキストの折り返しを許可
          ),
        ),
      ],
    );
  }
}
