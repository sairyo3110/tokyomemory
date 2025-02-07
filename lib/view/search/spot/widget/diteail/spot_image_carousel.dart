import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SpotImageCarousel extends StatelessWidget {
  final String placeId;

  SpotImageCarousel({required this.placeId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: PageView(
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/$placeId/1.png',
            fit: BoxFit.cover,
          ),
          CachedNetworkImage(
            imageUrl:
                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/$placeId/2.png',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
