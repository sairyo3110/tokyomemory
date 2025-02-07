import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlanSpotItem extends StatelessWidget {
  final String imageUrl;
  final String time;
  final String title;
  final String spot;
  final VoidCallback onTap;

  PlanSpotItem({
    required this.imageUrl,
    required this.time,
    required this.title,
    required this.spot,
    required this.onTap,
  });

  String removeSeconds(String time) {
    if (time.contains(':')) {
      List<String> parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}'; // 時間と分を返す
      }
    }
    return time; // ':'が含まれていない場合はそのまま返す
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover, // 画像を引き伸ばす
              width: double.infinity,
              height: double.infinity,
              errorWidget: (context, url, dynamic error) => Image.asset(
                'images/noimage.png', // 代替画像のパス
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Container(
              color: Colors.white.withOpacity(0.6), // 半透明の黒いオーバーレイ
            ),
            Positioned(
              top: 30,
              left: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align children at the start
                  children: [
                    Text(
                      removeSeconds(time),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          spot,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
