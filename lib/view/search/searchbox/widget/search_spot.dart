import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchSpot extends StatelessWidget {
  final String name;
  final String station;
  final String category;
  final String image;
  final VoidCallback onTap;

  SearchSpot(
      {required this.name,
      required this.station,
      required this.category,
      required this.onTap,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(width: 20),
          Container(
            height: 66,
            width: 66,
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover, // 画像を引き伸ばす
              errorWidget: (context, url, dynamic error) => Image.asset(
                'images/noimage.png', // 代替画像のパス
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 250,
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2, // 一行に制限
                ),
              ),
              Row(
                children: [
                  Text(
                    station,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "/",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
