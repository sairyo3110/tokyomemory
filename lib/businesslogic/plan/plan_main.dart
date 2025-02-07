import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/plan/plan.dart';
import 'package:mapapp/date/modeles/plan/plan_category.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/repository/plan/plan.dart';
import 'package:mapapp/repository/plan/plan_category.dart';
import 'package:mapapp/repository/spot/spot.dart'; // 追加

class PlanViewModel with ChangeNotifier {
  final PlanRepository _planRepository;
  final SpotRepository _spotRepository;
  final PlanCategoryRepository _planCategoryRepository; // 追加

  List<Plan> _plans = [];
  List<Plan> _filteredPlans = [];
  bool _isLoading = true;

  List<Plan> get plans => _plans;
  List<Plan> get filteredPlans => _filteredPlans;
  bool get isLoading => _isLoading;

  PlanViewModel(this._planRepository, this._spotRepository,
      this._planCategoryRepository); // 修正

  Future<void> loadPlans() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Plan> fetchedPlans = await _planRepository.fetchPlans();
      List<Spot> fetchedSpots =
          (await _spotRepository.fetchSpotAllDetails('places'))
              .map((place) => Spot.fromJson(place))
              .toList();
      List<PlanCategory> fetchedCategories =
          await _planCategoryRepository.fetchCategories(); // カテゴリを取得

      for (var plan in fetchedPlans) {
        Spot? mainSpot =
            fetchedSpots.firstWhere((spot) => spot.placeId == plan.mainSpotId);
        Spot? lunchSpot =
            fetchedSpots.firstWhere((spot) => spot.placeId == plan.lunchSpotId);
        Spot? subSpot =
            fetchedSpots.firstWhere((spot) => spot.placeId == plan.subSpotId);
        Spot? cafeSpot =
            fetchedSpots.firstWhere((spot) => spot.placeId == plan.cafeSpotId);
        Spot? dinnerSpot = fetchedSpots
            .firstWhere((spot) => spot.placeId == plan.dinnerSpotId);
        Spot? hotelSpot =
            fetchedSpots.firstWhere((spot) => spot.placeId == plan.hotelSpotId);

        plan.addSpotDetails(
            mainSpot, lunchSpot, subSpot, cafeSpot, dinnerSpot, hotelSpot);

        // カテゴリ名をプランに追加
        PlanCategory? category = fetchedCategories
            .firstWhere((cat) => cat.id == plan.planCategoryId);
        plan.addCategoryName(category.name);
      }

      _plans = fetchedPlans;
      _filteredPlans = fetchedPlans; // 初期表示はすべてのプラン
      filterPlans(""); // 初期ロード時にフィルタリングを適用
      print('plans loaded: ${_plans.length}');
    } catch (e) {
      print('Error loading plans: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterPlans(String query) {
    if (query.isEmpty) {
      _filteredPlans = _plans;
    } else {
      _filteredPlans = _plans.where((plan) {
        return plan.planName.contains(query);
      }).toList();
    }
    print('Filtered plans: ${_filteredPlans.length}');
    notifyListeners();
  }

  void filterPlansByCategory(String categoryName) {
    _filteredPlans = _plans.where((plan) {
      return plan.categoryName == categoryName;
    }).toList();
    print('Filtered plans by category: ${_filteredPlans.length}');
    notifyListeners();
  }

  List<Plan> getPlansBySpotId(int spotId) {
    return _plans
        .where((plan) =>
            plan.mainSpotId == spotId ||
            plan.lunchSpotId == spotId ||
            plan.subSpotId == spotId ||
            plan.cafeSpotId == spotId ||
            plan.dinnerSpotId == spotId ||
            plan.hotelSpotId == spotId)
        .toList();
  }
}
