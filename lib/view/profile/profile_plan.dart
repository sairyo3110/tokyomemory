import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/favorite/favorite_plan.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/search/plan/widget/plan_item.dart';
import 'package:mapapp/date/modeles/plan/plan.dart';
import 'package:mapapp/view/search/plan/plan_detail.dart';

class ProfilePlanList extends StatefulWidget {
  @override
  _ProfilePlanListState createState() => _ProfilePlanListState();
}

class _ProfilePlanListState extends State<ProfilePlanList> {
  final PlanFavoriteService _favoriteService = PlanFavoriteService();
  List<Plan> _favoritePlans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoritePlans();
  }

  Future<void> _loadFavoritePlans() async {
    try {
      // お気に入りプランのIDリストを取得
      List<int> favoritePlanIds =
          await _favoriteService.fetchUserFavoritesPlan();
      List<Plan> favoritePlans = [];

      // 各プランIDの詳細情報を取得
      for (int planId in favoritePlanIds) {
        Plan? plan = await _favoriteService.fetchPlanDetails(planId);
        if (plan != null) {
          favoritePlans.add(plan);
        }
      }

      setState(() {
        _favoritePlans = favoritePlans;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading favorite plans: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToPlanDetail(BuildContext context, Plan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanDetail(plan: plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseScreen(
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadFavoritePlans,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 一列に2つのアイテムを表示
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.7, // アイテムの縦横比を設定
                          ),
                          itemCount: _favoritePlans.length,
                          itemBuilder: (context, index) {
                            Plan plan = _favoritePlans[index];
                            return PlanItem(
                              imageUrl: plan.mainSpotId.toString(),
                              planTitle: plan.planName,
                              planDescription:
                                  plan.planComment ?? 'No description',
                              onTap: () {
                                _navigateToPlanDetail(context, plan);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
