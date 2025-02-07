import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/plan/plan_category.dart';
import 'package:mapapp/repository/plan/plan_category.dart';

class PlanCategoryModel with ChangeNotifier {
  List<String> _categories = [];
  List<String> _filteredCategories = [];
  bool _isLoading = false;

  List<String> get categories => _categories;
  List<String> get filteredCategories => _filteredCategories;
  bool get isLoading => _isLoading;

  final PlanCategoryRepository _controller = PlanCategoryRepository();

  Future<void> fetchPlanCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<PlanCategory> categories = await _controller.fetchCategories();
      _categories = categories.map((category) => category.name).toList();
      _filteredCategories = _categories; // 初期表示はすべてのカテゴリー
      print("Fetched plan categories: $_categories");
    } catch (e) {
      print("Error fetching plan categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterCategories(String query) {
    if (query.isEmpty) {
      _filteredCategories = _categories;
    } else {
      _filteredCategories = _categories.where((category) {
        return category.contains(query);
      }).toList();
    }
    print('Filtered categories: ${_filteredCategories.length}');
    notifyListeners();
  }
}
