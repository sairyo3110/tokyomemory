import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleNewCard extends StatelessWidget {
  final String images;
  final String title;
  final String category;
  final String date;
  final String url; // URLを追加

  ArticleNewCard({
    required this.images,
    required this.title,
    required this.category,
    required this.date,
    required this.url,
  });

  Future<void> _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        height: 90,
        child: Row(
          children: [
            CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: images,
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.label,
                        size: 12,
                      ),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 8,
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
