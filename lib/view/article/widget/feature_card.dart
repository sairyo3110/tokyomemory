import 'package:flutter/material.dart';

class ArticleFeatureCard extends StatelessWidget {
  final String images;
  final String title;
  ArticleFeatureCard({
    required this.images,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 角に丸みをつける
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // 影の位置を調整
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  images,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 50,
                ),
                Text("クーポンの表示")
              ],
            ),
          ),
          Positioned(
            top: 220,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), // 角に丸みをつける
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black, // 線の色を指定
                    width: 1, // 線の太さを指定
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
                  child: Text(
                    "一覧チェック",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
