import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/plan/plan_main.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/search/plan/plan_detail.dart';
import 'package:mapapp/view/search/plan/widget/plan_item.dart';
import 'package:mapapp/view/search/plan/widget/tab_widget.dart';
import 'package:provider/provider.dart';

class PlanMain extends StatefulWidget {
  @override
  _PlanMainState createState() => _PlanMainState();
}

class _PlanMainState extends State<PlanMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Search',
        showTitle: false,
        showSearchBox: true, // 検索ボックスを表示
      ),
      body: BaseScreen(
        body: Column(
          children: [
            //TODO プランのフィルタリングができるようになったら表示
            //PlanTabWidget(),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Consumer<PlanViewModel>(
                  builder: (context, planViewModel, child) {
                    if (planViewModel.plans.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 一列に2つのアイテムを表示
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.7, // アイテムの縦横比を設定
                      ),
                      itemCount: planViewModel.filteredPlans.length,
                      itemBuilder: (context, index) {
                        final plan = planViewModel.filteredPlans[index];
                        return PlanItem(
                          imageUrl:
                              'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.mainSpotId}/1.png', // 適切な画像URLに変更してください
                          planTitle: plan.planName,
                          planDescription:
                              plan.planComment ?? "", // 実際の説明に変更してください
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlanDetail(
                                        plan: plan,
                                      )), // PlanDetailにplanを渡す
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
