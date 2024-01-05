import 'package:mapapp/importer.dart';

class HomeViewModel {
  DatePlanController datePlanController = DatePlanController();

  // データの取得と更新
  Future<List<PlanCategory>> loadPlanCategories() async {
    try {
      return await PlanCategoryController().fetchCategories();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  Future<List<PlaceCategorySub>> loadPlaceCategories() async {
    try {
      var provider = PlacesProvider(); // コンテキストを渡さないように変更
      return await provider.fetchPlaceCategoriesSub();
    } catch (e) {
      print("Error fetching place categories: $e");
      return [];
    }
  }

  Future<DatePlan?> fetchDatePlanByCategory(int categoryId) async {
    try {
      return await datePlanController.fetchDatePlanById(categoryId);
    } catch (e) {
      print("Error fetching date plan by category: $e");
      return null;
    }
  }

  // アップデートチェック
  Future<bool> checkForUpdate() async {
    final appVersionController = AppVersionController(); // コンテキストを渡さないように変更
    return await appVersionController.isUpdateAvailable();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
