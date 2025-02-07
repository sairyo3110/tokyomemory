import 'package:flutter/material.dart';
import 'package:mapapp/view/carousel/constant/constants.dart';

class SearchImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = Constants.screenWidth(context);
    return Container(
      width: screenWidth,
      child: GestureDetector(
        onTap: () {
          //TODO デートAIのLINEリンクに遷移
        },
        child: Image.asset(
          'images/DateAi_banner.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
