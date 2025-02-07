import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SpotDiteailPlan extends StatelessWidget {
  final String name;
  final String category;
  final String image;
  final VoidCallback onTap;

  SpotDiteailPlan(
      {required this.name,
      required this.category,
      required this.onTap,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
            right: 100, top: 20, bottom: 20), // ここでタップできる領域を広げます
        child: Row(
          children: [
            SizedBox(width: 20),
            Container(
                height: 66,
                width: 66,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/$image/1.png',
                  fit: BoxFit.cover, // 画像を引き伸ばす
                  errorWidget: (context, url, dynamic error) => Image.asset(
                    'assets/noimage.png',
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
