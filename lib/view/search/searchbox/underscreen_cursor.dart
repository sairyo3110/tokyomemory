import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/plan/plan_chategory.dart';
import 'package:mapapp/businesslogic/plan/plan_main.dart';
import 'package:mapapp/businesslogic/spot/spot_chategory.dart';
import 'package:mapapp/businesslogic/spot/spot_main.dart';
import 'package:mapapp/location.dart';
import 'package:provider/provider.dart';
import 'package:mapapp/view/search/plan/plan_main.dart';
import 'package:mapapp/view/search/searchbox/widget/subtitle.dart';
import 'package:mapapp/view/search/searchbox/widget/title.dart';
import 'package:mapapp/view/search/spot/spot_main.dart';
import 'widget/tab_widget.dart';

class SearchBoxUnderscreen extends StatefulWidget {
  final VoidCallback onClose;

  SearchBoxUnderscreen({required this.onClose});

  @override
  _SearchBoxUnderscreenState createState() => _SearchBoxUnderscreenState();
}

class _SearchBoxUnderscreenState extends State<SearchBoxUnderscreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final spotProvider =
          Provider.of<SpotCategoriesSubProvider>(context, listen: false);
      spotProvider.fetchPlaceCategoriesSub(); // カテゴリーをフェッチする
    });
  }

  @override
  Widget build(BuildContext context) {
    final spotProvider = Provider.of<SpotCategoriesSubProvider>(context);
    final spotViewModel = Provider.of<SpotViewModel>(context, listen: false);
    final planCategoryModel = Provider.of<PlanCategoryModel>(context);
    final planViewModel = Provider.of<PlanViewModel>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // タップ時にキーボードを閉じる
      },
      behavior: HitTestBehavior.opaque, // タップイベントを確実にキャッチするために追加
      child: Container(
        height: MediaQuery.of(context).size.height - 58.0,
        child: Column(
          children: [
            SizedBox(height: 30),
            SearchBoxTitleText(
              text: "スポットを探す",
            ),
            SizedBox(height: 10),
            SearchBoxSubtitleText(text: "📌場所"),
            SizedBox(height: 10),
            SearchTextTabWidget(
              texts: FixedLocations.locations,
              onTabTap: (text) {
                spotViewModel.filterSpots(text);
                widget.onClose();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpotScreen()),
                );
              },
            ),
            SizedBox(height: 10),
            SearchBoxSubtitleText(text: "📌カテゴリー"),
            SizedBox(height: 10),
            if (spotProvider.isLoading)
              CircularProgressIndicator()
            else
              SearchTextTabWidget(
                texts: spotProvider.subCategories
                    .map((subCategory) => subCategory.name)
                    .toList(), // サブカテゴリのリストを渡す
                onTabTap: (text) {
                  spotViewModel.filterSpots(text);
                  widget.onClose();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpotScreen()),
                  );
                },
              ),
            SizedBox(height: 40),
            SearchBoxTitleText(
              text: "プランを探す",
            ),
            SizedBox(height: 10),
            SearchTextTabWidget(
              texts: planCategoryModel.categories, // プランカテゴリのリストを渡す
              onTabTap: (text) {
                planViewModel.filterPlansByCategory(text);
                widget.onClose();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlanMain()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
