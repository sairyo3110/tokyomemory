import 'package:mapapp/importer.dart';

class ArticleViewModel {
  final PlacesProvider placesProvider;
  final ClickInfo2Controller clickInfo2Controller;

  ArticleViewModel({
    required this.placesProvider,
    required this.clickInfo2Controller,
  });

  Future<List<Map<String, String?>>> fetchArticles() async {
    const url = 'https://sora-tokyo-dateplan.com/';
    final controller = WindowController();
    await controller.openHttp(uri: Uri.parse(url));

    final articleElements =
        controller.window.document.querySelectorAll('article.post-list-item');

    List<Map<String, String?>> fetchedArticles = [];

    for (var articleElement in articleElements) {
      var linkElement = articleElement.querySelector('a.post-list-link');
      var imageElement =
          articleElement.querySelector('div.post-list-thumb img');
      var titleElement = articleElement.querySelector('h2.post-list-title');
      var dateElement = articleElement.querySelector('span.post-list-date');
      var categoryElement = articleElement.querySelector('span.post-list-cat');

      var imageUrl = imageElement?.attributes['data-src'] ??
          imageElement?.attributes['src'];

      if (imageUrl?.startsWith('data:image') ?? false) {
        continue;
      }

      fetchedArticles.add({
        'imageUrl': imageUrl,
        'title': titleElement?.innerHtml,
        'date': dateElement?.innerHtml,
        'category': categoryElement?.text,
        'href': linkElement?.attributes['href'],
      });
    }

    return fetchedArticles;
  }

  Future<List<PlaceDetail>> fetchCoupons() async {
    try {
      List<PlaceDetail> fetchedCoupons =
          await placesProvider.fetchPlaceAllDetails('coupons');
      return fetchedCoupons.where((coupon) => coupon.categoryId == 24).toList();
    } catch (e) {
      print('クーポンの取得に失敗しました: $e');
      return [];
    }
  }

  Future<void> openArticle(String? href) async {
    if (href != null && await canLaunch(href)) {
      await launch(href);
    } else {
      throw 'Could not launch $href';
    }
  }
}
