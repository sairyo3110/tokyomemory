import 'package:flutter/material.dart';
import 'package:mapapp/view/carousel/widget/detial/explanation.dart';
import 'package:mapapp/view/carousel/widget/detial/tab.dart';
import 'package:mapapp/view/carousel/widget/detial/title.dart';

class CarouselDitailWidget extends StatelessWidget {
  final String text1;
  final String text2;
  final String title;
  final String explanation;
  final double screenWidth;

  CarouselDitailWidget({
    required this.text1,
    required this.text2,
    required this.title,
    required this.explanation,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth - 100,
      color: Colors.black.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (text1.isNotEmpty) CarouselTextTab(text: text1),
              SizedBox(width: 10),
              CarouselTextTab(text: text2),
            ],
          ),
          CarouselTitleText(text: title),
          CarouselExplanationText(text: explanation),
        ],
      ),
    );
  }
}
