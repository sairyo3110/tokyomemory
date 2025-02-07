import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/article.dart';
import 'package:mapapp/view/article/widget/card.dart';
import 'package:mapapp/view/article/widget/feature_card.dart';
import 'package:mapapp/view/article/widget/image.dart';
import 'package:mapapp/view/article/widget/new_card_list.dart';
import 'package:mapapp/view/article/widget/title.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:provider/provider.dart';

class ArticleScreen extends StatelessWidget {
  final List<String> imageUrls = [
    "images/SpemoCINEMA.png",
    "images/musch_shibuya.png",
    "images/musch_ikebukuro.png",
  ];

  @override
  Widget build(BuildContext context) {
    final articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);
    articleProvider.fetchArticles();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Holiday Tokyo',
      ),
      body: BaseScreen(
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ImageSlider(
                  imageUrls: imageUrls,
                  height: 220,
                  imageLinks: [
                    'https://sora-tokyo-dateplan.com/spemocinema/',
                    'https://sora-tokyo-dateplan.com/musch-shibuya/',
                    'https://sora-tokyo-dateplan.com/musch-ikebukuro/',
                  ],
                ),
                SizedBox(height: 20),
                ArticleTitleText(text: '新着記事'),
                Consumer<ArticleProvider>(
                  builder: (context, articleProvider, child) {
                    if (articleProvider.articles.isEmpty) {
                      return CircularProgressIndicator();
                    }
                    // 先頭5件の記事のみを取得
                    final topArticles =
                        articleProvider.articles.take(5).toList();
                    return ArticleList(
                      articles: topArticles.map((article) {
                        return {
                          'images': article.imageUrl ?? '',
                          'title': article.title ?? 'No Title',
                          'category': article.category ?? 'No Category',
                          'date': article.date ?? 'No Date',
                          'url': article.href ?? '',
                        };
                      }).toList(),
                    );
                  },
                ),
                // TODO クーポンフィルタリング等できるようになったら再掲
                //ArticleFeatureCard(
                //  images: 'images/biyou.png',
                //  title: '美容特集',
                //),
                ArticleTitleText(text: 'おすすめ'),
                ArticleCard(
                    images: 'images/date_view.png',
                    url: 'https://sora-tokyo-dateplan.com/date-view/'),
                ArticleCard(
                    images: 'images/fudousan.png',
                    url: 'https://sora-tokyo-dateplan.com/fudosan/'),
                SizedBox(height: 100)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
