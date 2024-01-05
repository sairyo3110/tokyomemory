import 'package:mapapp/importer.dart';

class SpotSelectionViewModel extends ChangeNotifier {
  List<PlaceCategorySub> _categories = [];
  bool _isLoadingCategories = true;
  // その他の状態変数を定義

  final PlacesProvider provider;

  SpotSelectionViewModel({required this.provider});

  List<PlaceCategorySub> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;

  get priceRange => null;

  Future<void> fetchCategories() async {
    _isLoadingCategories = true;
    notifyListeners();

    try {
      var categories = await provider.fetchPlaceCategoriesSub();
      _categories = categories.cast<PlaceCategorySub>();
      _isLoadingCategories = false;
      print('カテゴリー $_categories');
    } catch (error) {
      print('Failed to load categories: $error');
      // エラー処理を追加
      _isLoadingCategories = false;
    }

    notifyListeners();
  }

  List<String> _selectedLocations = [];

  List<String> get selectedLocations => _selectedLocations;

  void updateSelectedLocations(String value) {
    if (_selectedLocations.contains(value)) {
      _selectedLocations.remove(value);
    } else {
      _selectedLocations.add(value);
    }
    notifyListeners();
  }

  List<int> _selectedCategoryIds = [];

  List<int> get selectedCategoryIds => _selectedCategoryIds;

  void updateSelectedCategories(int categoryId) {
    if (_selectedCategoryIds.contains(categoryId)) {
      _selectedCategoryIds.remove(categoryId);
    } else {
      _selectedCategoryIds.add(categoryId);
    }
    notifyListeners();
  }

  List<int> _filteredPlaceIds = [];
  List<int> get filteredPlaceIds => _filteredPlaceIds;

  // 検索を実行し、結果を保存するメソッド
  Future<void> performSearch() async {
    try {
      var provider = PlacesProvider();
      _filteredPlaceIds = await provider.fetchFilteredPlaceIds(
        selectedLocations: _selectedLocations,
        minPrice: _minPrice ?? 0, // デフォルト値を設定
        maxPrice: _maxPrice ?? 1000000, // 適切なデフォルト値を設定
        selectedCategoryIds: _selectedCategoryIds,
      );
      notifyListeners();
    } catch (e) {
      print('Error performing search: $e');
      // エラー処理をここに追加
    }
  }

  int? _minPrice;
  int? _maxPrice;

  int? get minPrice => _minPrice;
  int? get maxPrice => _maxPrice;

  void updatePriceRange(int minPrice, int maxPrice) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    notifyListeners();
  }

  int? _selectedSubCategoryId;

  int? get selectedSubCategoryId => _selectedSubCategoryId;

  void updateSelectedSubCategoryId(int? categoryId) {
    _selectedSubCategoryId = categoryId;
    notifyListeners();
  }
}
