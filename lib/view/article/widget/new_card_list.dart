import 'package:flutter/material.dart';
import 'package:mapapp/view/article/widget/new_card.dart';

class ArticleList extends StatelessWidget {
  final List<Map<String, String>> articles;

  ArticleList({required this.articles});

  @override
  Widget build(BuildContext context) {
    double itemHeight = 120.0; // 各アイテムの高さ
    double totalHeight = itemHeight * articles.length; // 全アイテムの高さの合計

    return Container(
      height: totalHeight,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(), // スクロールを無効にする
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ArticleNewCard(
                images: article['images']!,
                title: article['title']!,
                category: article['category']!,
                date: article['date']!,
                url: article['url']!, // URLを追,
              ),
            );
          },
        ),
      ),
    );
  }
}
