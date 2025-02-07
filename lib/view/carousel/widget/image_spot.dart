import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/view/carousel/constant/constants.dart';

class CarouselSpotImage extends StatelessWidget {
  final int image;
  final int num;

  CarouselSpotImage({required this.image, required this.num});

  @override
  Widget build(BuildContext context) {
    final screenHeight = Constants.screenHeight(context);
    final screenWidth = Constants.screenWidth(context);
    final bottomNavigationHeight = Constants.bottomNavigationHeight;

    return Container(
      height: (screenHeight - bottomNavigationHeight) / 2,
      width: screenWidth,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/$image/$num.png',
            fit: BoxFit.cover, // 画像を引き伸ばす
            width: screenWidth,
            height: (screenHeight - bottomNavigationHeight) / 2,
            errorWidget: (context, url, dynamic error) => Image.asset(
              'images/noimage.png', // 代替画像のパス
              fit: BoxFit.cover,
              width: screenWidth,
              height: (screenHeight - bottomNavigationHeight) / 2,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.2), // 半透明の黒いオーバーレイ
          ),
        ],
      ),
    );
  }
}
