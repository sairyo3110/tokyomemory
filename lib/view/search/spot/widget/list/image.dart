import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SpotListImage extends StatelessWidget {
  final String image;

  SpotListImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      width: 92,
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover, // 画像を引き伸ばす
        errorWidget: (context, url, dynamic error) => Image.asset(
          'images/noimage.png', // 代替画像のパス
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
