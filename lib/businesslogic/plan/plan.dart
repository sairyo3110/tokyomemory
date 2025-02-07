import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/plan/plan.dart';
import 'package:mapapp/repository/plan/plan.dart';

class DatePlanProvider with ChangeNotifier {
  final PlanRepository _planRepository = PlanRepository();

  List<Plan> _datePlans = [];
  List<Plan> _filteredDatePlans = [];

  List<Plan> get datePlans => _datePlans;
  List<Plan> get filteredDatePlans => _filteredDatePlans;

  Future<void> loadDatePlans() async {
    _datePlans = await _planRepository.fetchPlans();
    _filteredDatePlans = List.from(_datePlans); // 初期状態ではすべてのプランを表示
    notifyListeners();
  }

  // 特定のカテゴリーIDに基づいてデートプランをフィルタリングするメソッド（void型）
  void filterPlansByCategoryId(int categoryId) async {
    print('filterPlansByCategoryId: $categoryId');
    // カテゴリーIDに基づいてフィルタリング
    _filteredDatePlans =
        _datePlans.where((plan) => plan.planCategoryId == categoryId).toList();

    print('filteredDatePlans: $_filteredDatePlans');

    notifyListeners(); // リスナーに変更を通知してUIを更新
  }

  // スポットIDに関連するデートプランを検索
  Future<Plan?> findDatePlanBySpotId(int spotId) async {
    // デートプランがまだロードされていない場合はロード
    if (_datePlans.isEmpty) {
      await loadDatePlans();
    }
    // スポットIDに関連するデートプランを検索
    for (Plan plan in _datePlans) {
      List<int> placeIds = [
        plan.mainSpotId,
        plan.lunchSpotId,
        plan.subSpotId,
        plan.cafeSpotId,
        plan.dinnerSpotId,
        plan.hotelSpotId,
      ];
      if (placeIds.contains(spotId)) {
        return plan;
      }
    }
    // 該当するデートプランがない場合はnullを返す
    return null;
  }

  void filterPlansByPlanId(int planId) {
    print('filterPlansByPlanId: $planId');
    // プランIDに基づいてフィルタリング
    _filteredDatePlans =
        _datePlans.where((plan) => plan.planId == planId).toList();

    print('filteredDatePlans: $_filteredDatePlans');

    notifyListeners(); // リスナーに変更を通知してUIを更新
  }

  Future<List<Plan>> filterPlansByPlanIds(List<int> planIds) async {
    print('filterPlansByPlanIds: $planIds');
    // デートプランがまだロードされていない場合はロード
    if (_datePlans.isEmpty) {
      await loadDatePlans();
    }
    // プランIDリストに基づいてフィルタリング
    List<Plan> filteredPlans =
        _datePlans.where((plan) => planIds.contains(plan.planId)).toList();

    print('filteredPlans: $filteredPlans');

    // フィルタリング結果を更新
    _filteredDatePlans = filteredPlans;
    notifyListeners(); // リスナーに変更を通知してUIを更新
    return filteredPlans; // フィルタリングされたプランのリストを返す
  }
}
