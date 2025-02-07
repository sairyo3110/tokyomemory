import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleCard extends StatelessWidget {
  final String images;
  final String url;

  ArticleCard({required this.images, required this.url});

  Future<void> _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: _launchURL,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // 角に丸みをつける
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // 影の位置を調整
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), // 画像の角に丸みをつける
            child: Image.asset(
              images,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
