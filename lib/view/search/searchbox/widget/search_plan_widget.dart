import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/plan/plan.dart';
import 'package:mapapp/view/search/searchbox/widget/search_plan.dart';

class SearchPlanWidget extends StatelessWidget {
  final List<Plan> plans;
  final Function(int) onSpotTap;

  SearchPlanWidget({required this.plans, required this.onSpotTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // スクロールを無効にする
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Column(
          children: [
            SearchPlan(
              name: plan.planName, // デフォルト値を設定
              station: plan.categoryName ?? '駅名がありません', // デフォルト値を設定
              category: "カテゴリー", // デフォルト値を設定
              image:
                  'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${plan.mainSpotId}/1.png', // デフォルト値を設定
              onTap: () => onSpotTap(index),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
