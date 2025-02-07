import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot_chategory.dart';
import 'package:mapapp/repository/spot/spot.dart';

class SpotCategoriesSubProvider with ChangeNotifier {
  List<SpotCategorySub> _subCategories = [];
  bool _isLoading = false;

  List<SpotCategorySub> get subCategories => _subCategories;
  bool get isLoading => _isLoading;

  final SpotRepository _repository = SpotRepository();

  Future<void> fetchPlaceCategoriesSub() async {
    _isLoading = true;
    try {
      _subCategories = (await _repository.fetchPlaceCategoriesSub())
          .map((subCategory) => SpotCategorySub.fromJson(subCategory))
          .toList();
    } catch (error) {
      print("Error fetching subcategories: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
