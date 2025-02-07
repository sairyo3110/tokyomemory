import 'package:flutter/material.dart';
import 'package:mapapp/view/search/spot/widget/list/image.dart';

class SpotListImageWidget extends StatelessWidget {
  final List<String> image;

  SpotListImageWidget({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // 高さを設定
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 横方向にスクロール
        padding: EdgeInsets.only(left: 10), // 左側にパディングを追加
        itemCount: image.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              SpotListImage(
                image: image[index],
              ),
              SizedBox(width: 10), // 各タブの間にスペースを追加
            ],
          );
        },
      ),
    );
  }
}
