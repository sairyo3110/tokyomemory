import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/plan/plan_chategory.dart';
import 'package:mapapp/businesslogic/plan/plan_main.dart';
import 'package:mapapp/view/search/plan/plan_detail.dart';
import 'package:mapapp/view/search/plan/plan_main.dart';
import 'package:mapapp/view/search/searchbox/widget/area_widget.dart';
import 'package:mapapp/view/search/searchbox/widget/line.dart';
import 'package:mapapp/view/search/searchbox/widget/search_plan_widget.dart';
import 'package:mapapp/view/search/searchbox/widget/title.dart';
import 'package:provider/provider.dart';

class PlanSearchBoxUnderscreen extends StatelessWidget {
  final VoidCallback onClose;

  PlanSearchBoxUnderscreen({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PlanCategoryModel, PlanViewModel>(
      builder: (context, categoryViewModel, planViewModel, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // 最後の項目が表示されるように余白を追加
            child: Column(
              children: [
                SizedBox(height: 30),
                if (categoryViewModel.filteredCategories.isNotEmpty) ...[
                  SearchBoxTitleText(
                    text: "エリア",
                  ),
                  SearchAreawidget(
                    locations: categoryViewModel.filteredCategories,
                    onLocationTap: (location) {
                      planViewModel.filterPlansByCategory(location);
                      onClose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlanMain()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  SearchLine(),
                ],
                if (planViewModel.filteredPlans.isNotEmpty) ...[
                  SizedBox(height: 30),
                  SearchBoxTitleText(
                    text: "プラン",
                  ),
                  SearchPlanWidget(
                    plans: planViewModel.filteredPlans,
                    onSpotTap: (index) {
                      onClose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlanDetail(
                              plan: planViewModel.filteredPlans[index]),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 500),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
