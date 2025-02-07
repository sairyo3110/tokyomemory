import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/repository/spot/spot.dart';

class SpotProvider with ChangeNotifier {
  final SpotRepository _repository = SpotRepository();

  List<Spot> _places = [];
  List<Spot> _allPlaces = []; // 全ての場所を保持するリスト
  bool _isLoading = true; // データ取得状態のフラグ
  bool _isSortedByDistance = false; // ソート状態の追跡
  bool _sortAscending = true; // ソート方向の状態（true: 昇順、false: 降順）

  List<Spot> get places => _places;
  bool get isLoading => _isLoading;
  bool get isSortedByDistance => _isSortedByDistance;
  bool get sortAscending => _sortAscending;

  Future<void> fetchPlaces() async {
    _isLoading = true;
    notifyListeners();
    _allPlaces = (await _repository.fetchSpotAllDetails('places'))
        .map((place) => Spot.fromJson(place))
        .toList();

    // ここで現在地から近い順に並び替え
    _sortPlacesByDistance();

    _isLoading = false;
    print(_allPlaces.length);
    Future.microtask(() => notifyListeners());
  }

  Future<List<Spot>> fetchFilteredPlaceDetails(List<int> placeIds) async {
    await fetchPlaces();
    List<Spot> allPlaces = _allPlaces;
    List<Spot> filteredPlaces = [];

    for (int id in placeIds) {
      filteredPlaces.addAll(allPlaces.where((place) => place.placeId == id));
    }

    return filteredPlaces;
  }

  void filterPlaces(List<String> filterOptions) {
    // フィルタリングオプションを更新
    if (filterOptions.isEmpty) {
      _places = List.from(_allPlaces);
    } else {
      _places = _allPlaces.where((place) {
        // どのフィルターオプションにも当てはまる場所をリストに含める
        return filterOptions
            .any((option) => place.city?.contains(option) ?? false);
      }).toList();
    }

    if (_isSortedByDistance) {
      _sortPlacesByDistance();
    }

    notifyListeners();
  }

  void sortByDistance() {
    // ソート状態をトグル
    _isSortedByDistance = !_isSortedByDistance;
    _sortPlacesByDistance();
    notifyListeners();
  }

  void toggleSortDirection() {
    _sortAscending = !_sortAscending; // ソート方向をトグル
    _sortPlacesByDistance(); // 新しいソート方向でリストをソート
    notifyListeners();
  }

  void _sortPlacesByDistance() {
    // 現在地からの距離で_allPlacesリストを昇順にソート
    _allPlaces.sort((a, b) {
      double distanceA = calculateDistance(
          currentLatitude, currentLongitude, a.latitude!, a.longitude!);
      double distanceB = calculateDistance(
          currentLatitude, currentLongitude, b.latitude!, b.longitude!);
      return distanceA.compareTo(distanceB);
    });

    // _placesリストも同様にソート
    _places = List.from(_allPlaces);

    notifyListeners();
  }

  double currentLatitude = 35.658581;
  double currentLongitude = 139.745433;

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var dLat = lat1 - lat2;
    var dLon = lon1 - lon2;
    return dLat * dLat + dLon * dLon;
  }

  void searchPlaces(String query) {
    if (query.isEmpty) {
      _places = List.from(_allPlaces);
    } else {
      query = query.toLowerCase();
      _places = _allPlaces.where((place) {
        String name = place.name?.toLowerCase() ?? '';
        String description = place.description?.toLowerCase() ?? '';
        String city = place.city?.toLowerCase() ?? '';
        return name.contains(query) ||
            description.contains(query) ||
            city.contains(query);
      }).toList();
    }

    // 検索後に現在のソート状態が距離に基づいている場合は、ソートを適用
    if (_isSortedByDistance) {
      _sortPlacesByDistance();
    }

    notifyListeners();
  }

  void filterByMinMaxRange(int minPrice, int maxPrice) {
    _places = _allPlaces.where((place) {
      // 文字列をdoubleに変換し、0.5を足して整数に丸める（四捨五入）
      int placeNightMin =
          (double.tryParse(place.nightMin ?? '0.0') ?? 0.0).round();
      int placeNightMax =
          (double.tryParse(place.nightMax ?? '999999.0') ?? 999999.0).round();

      return placeNightMin >= minPrice && placeNightMax <= maxPrice;
    }).toList();

    notifyListeners();
  }

  // 地名と金額に基づいてフィルタリングするメソッド
  void filterPlacesAndPrice(
      List<String> selectedCities, int minPrice, int maxPrice) {
    _isLoading = true;
    notifyListeners();

    // 地名に基づくフィルタリング
    List<Spot> filteredByCity = _places.where((place) {
      return selectedCities.any((city) => place.city?.contains(city) ?? false);
    }).toList();

    // 金額に基づくフィルタリング
    List<Spot> finalFiltered = filteredByCity.where((place) {
      int placeNightMin = int.tryParse(place.nightMin ?? '0') ?? 0;
      int placeNightMax = int.tryParse(place.nightMax ?? '999999') ?? 999999;
      return placeNightMin <= maxPrice && placeNightMax >= minPrice;
    }).toList();

    // フィルタリング結果を設定
    _places = finalFiltered;
    _isLoading = false;
    notifyListeners();
  }

  // カテゴリーIDに基づいてフィルタリングするメソッド
  void filterPlacesByCategories(List<int> categoryIds) {
    _isLoading = true;
    notifyListeners();

    // カテゴリーIDのリストに基づくフィルタリング
    _places = _allPlaces.where((place) {
      // place.subcategoryId が null でない、かつ、カテゴリーIDのリストに含まれているかチェック
      return place.subcategoryId != null &&
          categoryIds.contains(place.subcategoryId);
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  void filterPlacesAndPriceAndCategory(List<String> selectedCities,
      int minPrice, int maxPrice, List<int> selectedCategoryIds) {
    _isLoading = true;
    notifyListeners();

    // 地名（または駅名）、金額、カテゴリーIDに基づくフィルタリング
    List<Spot> filtered = _allPlaces.where((place) {
      bool matchesCityOrStation = selectedCities.isEmpty ||
          selectedCities.any((cityOrStation) =>
              (place.city?.contains(cityOrStation) ?? false) ||
              (place.nearestStation?.contains(cityOrStation) ?? false));
      // 文字列をintに変換し、変換できない場合はデフォルト値を使用
      int placeNightMinInt = int.tryParse(place.nightMin ?? '') ?? 0;
      int placeNightMaxInt = int.tryParse(place.nightMax ?? '') ?? 999999;

      bool matchesPrice =
          placeNightMinInt <= maxPrice && placeNightMaxInt >= minPrice;

      bool matchesCategory = selectedCategoryIds.isEmpty ||
          selectedCategoryIds.contains(place.subcategoryId);

      return matchesCityOrStation && matchesPrice && matchesCategory;
    }).toList();

    _places = filtered;
    _isLoading = false;
    print(_places.length);
    notifyListeners();
  }

  void filterCouponAndPriceAndCategory(List<String> selectedCities,
      int minPrice, int maxPrice, List<int> selectedCategoryIds) {
    _isLoading = true;
    notifyListeners();

    // 最初に、couponIdがnullでない場所のみをフィルタリング
    List<Spot> placesWithCoupons = _allPlaces.where((place) {
      return place.cCouponId != null; // couponIdがnullでない場所のみを選択
    }).toList();

    // 地名、金額、カテゴリーIDに基づくフィルタリングをクーポンがある場所のリストに適用
    List<Spot> filtered = placesWithCoupons.where((place) {
      bool matchesCityOrStation = selectedCities.isEmpty ||
          selectedCities.any((cityOrStation) =>
              (place.city?.contains(cityOrStation) ?? false) ||
              (place.nearestStation?.contains(cityOrStation) ?? false));
      int placeNightMinInt = int.tryParse(place.nightMin ?? '') ?? 0;
      int placeNightMaxInt = int.tryParse(place.nightMax ?? '') ?? 999999;
      bool matchesPrice =
          placeNightMinInt <= maxPrice && placeNightMaxInt >= minPrice;
      bool matchesCategory = selectedCategoryIds.isEmpty ||
          selectedCategoryIds.contains(place.subcategoryId);

      return matchesCityOrStation && matchesPrice && matchesCategory;
    }).toList();

    _places = filtered;
    _isLoading = false;
    notifyListeners();
  }

  // couponIdがNullではない情報を取得するメソッド
  void filterPlacesByAvailableCoupons() {
    _isLoading = true;
    notifyListeners();

    // couponIdがnullでない場合のみのフィルタリング
    _places = _allPlaces.where((place) {
      return place.cCouponId != null; // couponIdがnullでない場合にtrueを返す
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  List<Spot> _coupons = [];

  List<Spot> get coupons => _coupons;

  Future<void> fetchCoupons() async {
    try {
      List<Spot> fetchedCoupons =
          await fetchFilteredPlaceDetails([514]); // 修正: 'coupons'から514に変更

      // categoryIdが24のクーポンだけを抽出（例としてplaceIdが514を使用）
      List<Spot> filteredCoupons =
          fetchedCoupons.where((coupon) => coupon.placeId == 514).toList();

      // 状態を更新
      _coupons = filteredCoupons;
      notifyListeners();
    } catch (e) {
      print('クーポンの取得に失敗しました: $e');
      // エラーハンドリングをここに追加
    }
  }

  // PlacesProviderまたはそれに相当するクラスのfindSpotIndexByLatLng関数
  int findSpotIndexByLatLng(double latitude, double longitude) {
    int index = places.indexWhere(
        (spot) => spot.paLatitude == latitude && spot.paLongitude == longitude);
    print('findSpotIndexByLatLng called, found index: $index');
    return index;
  }

  void shufflePlaces() {
    final random = Random();
    // _placesリストをランダムに並び替えます。_allPlacesリストをランダムにしたい場合は、
    // 下記コードで_allPlacesを_shufflePlacesの対象としてください。
    _places.shuffle(random);

    // リストが更新されたことをリスナーに通知
    notifyListeners();
  }
}
