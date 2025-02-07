import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/view/carousel/constant/constants.dart';

class CarouselPlanImage extends StatelessWidget {
  final String image;

  CarouselPlanImage({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = Constants.screenHeight(context);
    final screenWidth = Constants.screenWidth(context);
    final bottomNavigationHeight = Constants.bottomNavigationHeight;

    return Container(
      height: (screenHeight - bottomNavigationHeight) / 4,
      width: screenWidth / 2,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover, // 画像を引き伸ばす
            width: screenWidth / 2,
            height: (screenHeight - bottomNavigationHeight) / 4,
            errorWidget: (context, error, stackTrace) {
              return Center(
                child: Image.asset(
                  'images/noimage.png',
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Container(
            color: Colors.black.withOpacity(0.2), // 半透明の黒いオーバーレイ
          ),
        ],
      ),
    );
  }
}
