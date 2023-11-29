import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/model/clickinfo2.dart';
import 'package:mapapp/repository/clickInfo_controller2.dart';
import 'package:mapapp/test/places_provider.dart';
import 'package:mapapp/test/rerated_model.dart';
import 'package:mapapp/view/coupon/coupon_detail_screen.dart';
import 'package:universal_html/controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleView extends StatefulWidget {
  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final ScrollController _scrollController = ScrollController();
  double _appBarHeight = 80.0;
  Alignment _alignment = Alignment.centerLeft;
  double _fontSize = 40.0;
  List<PlaceDetail> coupons = [];

  List<Map<String, String?>> articles = [];

  final ClickInfo2Controller _clickInfo2Controller = ClickInfo2Controller();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchArticles();
    _fetchCoupons(); // Fetch coupons when the state initializes
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _appBarHeight = max(50.0, 80.0 - offset); // スクロールに応じてAppBarの高さを変更
      _fontSize = max(20.0, 40.0 - offset); // スクロールに応じてフォントサイズを変更
      if (offset > 20.0) {
        // 20.0は適当な閾値、実際には適切な値を設定する必要があります
        _alignment = Alignment.center; // スクロールが一定量進んだらセンターに配置
      } else {
        _alignment = Alignment.centerLeft; // それ以外の場合は左寄せ
      }
    });
  }

  Future<void> _fetchArticles() async {
    const url = 'https://sora-tokyo-dateplan.com/';
    final controller = WindowController();
    await controller.openHttp(uri: Uri.parse(url));

    // Select all article elements
    final articleElements =
        controller.window.document.querySelectorAll('article.post-list-item');

    List<Map<String, String?>> fetchedArticles = [];

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

      fetchedArticles.add({
        'imageUrl': imageUrl,
        'title': titleElement?.innerHtml,
        'date': dateElement?.innerHtml,
        'category': categoryElement?.text, // カテゴリー情報を追加します。
        'href': linkElement?.attributes['href'],
      });
    }

    setState(() {
      articles = fetchedArticles;
    });
  }

  Widget _buildImage(String? imageUrl) {
    // Debug print statement

    if (imageUrl == null || imageUrl.isEmpty) {
      // URLがnullまたは空の場合にプレースホルダーを返します
      return const Icon(Icons.image_not_supported);
    }

    if (imageUrl.startsWith('data:image')) {
      // base64文字列です
      final base64Data = imageUrl.split('base64,')[1];
      Uint8List bytes;
      try {
        bytes = base64Decode(base64Data);
      } catch (e) {
        // Debug print statement for decode failure
        return const Icon(Icons.error);
      }
      return Image.memory(bytes, fit: BoxFit.cover);
    }

    // ネットワーク画像です
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Debug print statement for network image loading failures
        return const Icon(Icons.broken_image);
      },
    );
  }

  Future<void> _fetchCoupons() async {
    try {
      PlacesProvider placesProvider = PlacesProvider(context);
      List<PlaceDetail> fetchedCoupons =
          await placesProvider.fetchPlaceAllDetails('coupons');

      // categoryIdが24のクーポンだけを抽出
      List<PlaceDetail> filteredCoupons =
          fetchedCoupons.where((coupon) => coupon.categoryId == 24).toList();

      // 状態を更新
      setState(() {
        coupons = filteredCoupons;
      });
    } catch (e) {
      print('クーポンの取得に失敗しました: $e');
      // エラーハンドリングをここに追加
    }
  }

  bool _showMore = false; // New state variable

  @override
  Widget build(BuildContext context) {
    final int articlesToShow =
        _showMore ? articles.length : min(articles.length, 5);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight), // AppBarの縦幅を100.0に設定
        child: AppBar(
          title: Container(
            padding: EdgeInsets.all(8.0), // 余白を追加
            alignment: _alignment, // alignmentを動的に設定
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0), // 上に10.0の余白を追加
                Text(
                  'Special feature',
                  style: TextStyle(
                    color: Color(0xFFF6E6DC),
                    fontSize: _fontSize, // 文字サイズを40.0に設定
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          elevation: 0, // 影を消す
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        controller: _scrollController, // ScrollControllerを指定
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20.0), // 余白を追加
              alignment: Alignment.centerLeft, // 左寄せ
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0), // 上に10.0の余白を追加
                  Text(
                    '思い出に残る素敵なデートを',
                    style: TextStyle(
                      color: Color(0xFFF6E6DC),
                      fontSize: 20, // 文字サイズを40.0に設定
                      fontWeight: FontWeight.w900, // ここを変更
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                final String? userId = await getCurrentUserId();
                if (userId != null) {
                  final ClickInfo2 clickInfo2 = ClickInfo2(
                    userId: userId,
                    couponId: 99999, // 適切なクーポンIDを指定する
                    clickedAt: DateTime.now(),
                  );
                  await _clickInfo2Controller.saveClickInfo2(clickInfo2);
                  const url =
                      'https://sora-tokyo-dateplan.com/jrk-enplace-collaboration/'; // ここに目的のURLを入力してください
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            12), // Set the radius of the corner here
                      ),
                      child: ClipRRect(
                        // This widget rounds the corners of the image
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'images/jr.png',
                          width: 325,
                          fit: BoxFit
                              .cover, // Set the image to fit the Container
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '素敵なホテルをゆっくり過ごせるスペシャルコラボ！',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '詳しく見る',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.all(20.0), // 余白を追加
              alignment: Alignment.centerLeft, // 左寄せ
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0), // 上に10.0の余白を追加
                  Text(
                    '新着記事',
                    style: TextStyle(
                      color: Color(0xFFF6E6DC),
                      fontSize: 20, // 文字サイズを40.0に設定
                      fontWeight: FontWeight.w900, // ここを変更
                    ),
                  ),
                ],
              ),
            ),
            ...articles.take(articlesToShow).map((article) {
              return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    // InkWellを追加
                    onTap: () async {
                      var url = article['href']; // 'url'は記事のデータモデルにあるURLキーです
                      if (await canLaunch(url!)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex:
                              3, // Increased flex factor, the image will take more space.
                          child: AspectRatio(
                            aspectRatio: 16 / 9, // Wider aspect ratio
                            child: _buildImage(article['imageUrl']),
                          ),
                        ),
                        Expanded(
                          flex:
                              3, // Adjust the flex factor to control the width proportion
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Icon(Icons.label, size: 10.0), // カテゴリーのアイコン
                                    SizedBox(width: 4.0), // アイコンとテキストの間にスペースを追加
                                    Expanded(
                                      child: Text(
                                        article['category'] ??
                                            'No Category', // カテゴリーを表示する
                                        style: TextStyle(
                                          fontSize: 8.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // 長すぎるテキストを省略
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  article['title'] ?? 'No Title', // タイトルを表示する
                                  style: TextStyle(
                                    fontSize: 12.0, // タイトルのフォントサイズを小さくする
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  article['date'] ?? 'No Date', // 日付を表示する
                                  style: TextStyle(
                                    fontSize: 8.0,
                                    color:
                                        Colors.grey.shade600, // 日付のフォントカラーを設定
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            }).toList(),
            if (articles.length >
                5) // Only show the button if there are more than 5 articles
              TextButton(
                onPressed: () {
                  setState(() {
                    _showMore = true; // Update the state to show all articles
                  });
                },
                child: Text(
                  _showMore ? '' : 'もっと見る',
                  style: TextStyle(
                    color: Color(0xFFF6E6DC),
                  ),
                ),
              ),
            Container(
              padding: EdgeInsets.all(20.0), // 余白を追加
              alignment: Alignment.centerLeft, // 左寄せ
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0), // 上に10.0の余白を追加
                  Text(
                    '美容クーポン特集',
                    style: TextStyle(
                      color: Color(0xFFF6E6DC),
                      fontSize: 20, // 文字サイズを40.0に設定
                      fontWeight: FontWeight.w900, // ここを変更
                    ),
                  ),
                ],
              ),
            ),
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.asset(
                      'images/biyou.png',
                      width: 350,
                      height: 200, // Specify the height for image
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'デートを最高の状態で迎えたいあなたに、美容系のクーポンをまとめました！',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    height: 190,
                    child: coupons.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: coupons.length,
                            itemBuilder: (_, index) {
                              final coupon = coupons[index];
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CouponDetailScreen(coupon: coupon),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize
                                          .min, // To wrap the column content
                                      children: [
                                        Image.network(
                                          "https://mymapapp.s3.ap-northeast-1.amazonaws.com/coupon/${coupon.name}/1.png",
                                          width: 180,
                                          height:
                                              100, // Define a fixed height for consistency
                                          fit: BoxFit.cover,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              6.0), // アイコンとテキスト用のパディング
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 160.0, // コンテナの幅を180に設定
                                                child: Text(
                                                  coupon.name ??
                                                      '', // ここにテキストが入ります
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        12.0, // フォントサイズを調整
                                                  ),
                                                  overflow: TextOverflow
                                                      .ellipsis, // テキストが長すぎる場合は省略記号を表示
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              8.0), // アイコンとテキスト用のパディング
                                          child: Row(
                                            // Rowを維持
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center, // 子を中央に配置
                                            children: [
                                              Icon(Icons.route,
                                                  size: 12.0), // 経路アイコン
                                              SizedBox(
                                                  width:
                                                      8.0), // アイコンとテキストの間のスペース
                                              Container(
                                                width: 140.0, // コンテナの幅を180に設定
                                                child: Text(
                                                  '${coupon.nearestStation}より ${coupon.walkingMinutes}分', // ここにテキストが入ります
                                                  style: TextStyle(
                                                    fontSize:
                                                        10.0, // フォントサイズを調整
                                                  ),
                                                  overflow: TextOverflow
                                                      .ellipsis, // テキストが長すぎる場合は省略記号を表示
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0), // 余白を追加
              alignment: Alignment.centerLeft, // 左寄せ
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0), // 上に10.0の余白を追加
                  Text(
                    '安心安全に出会うなら',
                    style: TextStyle(
                      color: Color(0xFFF6E6DC),
                      fontSize: 20, // 文字サイズを40.0に設定
                      fontWeight: FontWeight.w900, // ここを変更
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                final String? userId = await getCurrentUserId();
                if (userId != null) {
                  final ClickInfo2 clickInfo2 = ClickInfo2(
                    userId: userId,
                    couponId: 99999, // 適切なクーポンIDを指定する
                    clickedAt: DateTime.now(),
                  );
                  await _clickInfo2Controller.saveClickInfo2(clickInfo2);
                  const url =
                      'https://match-apps.com/ranking/'; // ここに目的のURLを入力してください
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            12), // Set the radius of the corner here
                      ),
                      child: ClipRRect(
                        // This widget rounds the corners of the image
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'images/matc.jpg',
                          width: 325,
                          fit: BoxFit
                              .cover, // Set the image to fit the Container
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '実際のユーザーの声を聞いたリアルな記事',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '詳しく見る',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.all(20.0), // 余白を追加
              alignment: Alignment.centerLeft, // 左寄せ
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0), // 上に10.0の余白を追加
                  Text(
                    '素敵な将来のお手伝い',
                    style: TextStyle(
                      color: Color(0xFFF6E6DC),
                      fontSize: 20, // 文字サイズを40.0に設定
                      fontWeight: FontWeight.w900, // ここを変更
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                final String? userId = await getCurrentUserId();
                if (userId != null) {
                  final ClickInfo2 clickInfo2 = ClickInfo2(
                    userId: userId,
                    couponId:
                        000, // Make sure to replace 000 with the actual couponId if needed
                    clickedAt: DateTime.now(),
                  );
                  await _clickInfo2Controller.saveClickInfo2(clickInfo2);
                  const url =
                      'https://sora-tokyo-dateplan.com/fudosan/'; // Enter the target URL here
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            12), // Set the radius of the corner here
                      ),
                      child: ClipRRect(
                        // This widget rounds the corners of the image
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'images/fudousan.png',
                          width: 325,
                          fit: BoxFit
                              .cover, // Set the image to fit the Container
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '同棲を考えているカップル必見！カップルに詳しいデートアカウントだからこそ紹介できる最高の同棲物件をご紹介します！',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '詳しく見る',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> getCurrentUserId() async {
    try {
      var currentUser =
          await Amplify.Auth.getCurrentUser(); // Amplifyをインポートする必要があります
      return currentUser.userId;
    } on AuthException catch (e) {
      // AuthExceptionをインポートする必要があります
      print(e);
      return null;
    }
  }

  void _openArticle(String? href) async {
    if (href != null && await canLaunch(href)) {
      await launch(href);
    } else {
      throw 'Could not launch $href';
    }
  }
}
