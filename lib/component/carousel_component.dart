import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselComponent extends StatelessWidget {
  final List<String> imgList;
  final Function(String) onTapItem;

  CarouselComponent({required this.imgList, required this.onTapItem});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
        onPageChanged: (index, reason) {},
      ),
      items: imgList.map((item) {
        return GestureDetector(
          onTap: () => onTapItem(item),
          child: Container(
            child: Center(
              child: Image.asset(item, fit: BoxFit.cover, width: 1000),
            ),
          ),
        );
      }).toList(),
    );
  }
}
