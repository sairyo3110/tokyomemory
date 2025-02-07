import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotDetailWebWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String url;

  SpotDetailWebWidget({
    required this.icon,
    required this.text,
    required this.url,
  });

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(url), // タップでURLを開く
      child: Row(
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
                decoration: TextDecoration.underline, // 下線を追加
              ),
              softWrap: true, // テキストの折り返しを許可
            ),
          ),
        ],
      ),
    );
  }
}
