import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/article.dart';
import 'package:universal_html/controller.dart';

class ArticleProvider extends ChangeNotifier {
  List<Article> _articles = [];

  List<Article> get articles => _articles;

  Future<void> fetchArticles() async {
    const url = 'https://sora-tokyo-dateplan.com/';
    final controller = WindowController();
    await controller.openHttp(uri: Uri.parse(url));

    // Select all article elements
    final articleElements =
        controller.window.document.querySelectorAll('article.post-list-item');

    List<Article> fetchedArticles = [];

    for (var articleElement in articleElements) {
      var linkElement = articleElement.querySelector('a.post-list-link');
      var imageElement =
          articleElement.querySelector('div.post-list-thumb img');
      var titleElement = articleElement.querySelector('h2.post-list-title');
      var dateElement = articleElement.querySelector('span.post-list-date');
      var categoryElement = articleElement
          .querySelector('span.post-list-cat'); // これがカテゴリー情報を取得するセレクターです。

      // Check for 'data-src' or 'src' attributes for the image URL
      var imageUrl = imageElement?.attributes['data-src'] ??
          imageElement?.attributes['src'];

      // Skip if image URL is a base64 string
      if (imageUrl?.startsWith('data:image') ?? false) {
        continue; // Skip this iteration if the image URL is base64
      }

      fetchedArticles.add(Article(
        imageUrl: imageUrl,
        title: titleElement?.innerHtml,
        date: dateElement?.innerHtml,
        category: categoryElement?.text,
        href: linkElement?.attributes['href'],
      ));
    }

    _articles = fetchedArticles;
    notifyListeners();
  }
}
