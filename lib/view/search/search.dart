import 'package:flutter/material.dart';
import 'package:mapapp/view/article/widget/card.dart';
import 'package:mapapp/view/common/advertisement_banner_image.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/search/widget/search/icon_widget.dart';
import 'package:mapapp/view/search/widget/search/title.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Search',
        showTitle: false,
        showSearchBox: true, // 検索ボックスを表示
      ),
      body: BaseScreen(
        body: SingleChildScrollView(
          child: Column(
            children: [
              LoggableImage(
                imagePath: 'images/ad_banner.png',
                logEventName: 'search_spot',
                logParameters: {'spot_id': 1},
                link: 'https://sora-tokyo-dateplan.com/spemocinema/',
              ),
              const SizedBox(height: 20),
              SearchIconWidget(),
              const SizedBox(height: 10),
              // TODO デートAIを後々実装
              //SearchImage(),
              const SizedBox(height: 10),
              SearchTitleText(text: 'おすすめ記事'),
              ArticleCard(
                  images: 'images/date_view.png',
                  url: 'https://sora-tokyo-dateplan.com/date-view/'),
              ArticleCard(
                  images: 'images/fudousan.png',
                  url: 'https://sora-tokyo-dateplan.com/fudosan/'),
            ],
          ),
        ),
      ),
    );
  }
}
