import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/date/modeles/spot/spot_chategory.dart';
import 'package:mapapp/location.dart';
import 'package:mapapp/repository/spot/spot.dart';
import 'package:mapapp/service/map/location_service.dart';
import 'package:provider/provider.dart';
import 'package:mapapp/businesslogic/spot/spot_chategory.dart';
import 'package:mapapp/businesslogic/spot/spot_access.dart';

class SpotViewModel with ChangeNotifier {
  final SpotRepository _repository;
  List<Spot> _spots = [];
  List<Spot> _filteredSpots = [];
  List<String> _areas = FixedLocations.locations; // 固定の値を使用
  List<String> _filteredAreas = [];
  List<String> _filteredStations = [];
  bool _isLoading = true;
  List<SpotCategorySub> _subCategories = [];
  LocationService _locationService = LocationService();

  SpotViewModel(this._repository);

  List<Spot> get spots => _spots;
  List<Spot> get filteredSpots => _filteredSpots;
  List<String> get filteredAreas => _filteredAreas;
  List<String> get filteredStations => _filteredStations;
  bool get isLoading => _isLoading;

  void filterLocations(String query, PlaceAccessViewModel accessViewModel) {
    _filteredAreas = _areas.where((area) => area.contains(query)).toList();
    _filteredStations = accessViewModel.placeAccesses
        .map((e) => e.nearestStation)
        .where((station) => station.contains(query))
        .toList();
    filterSpots(query);
    notifyListeners();
  }

  Future<void> filterSpots(String query) async {
    if (query.isEmpty) {
      _filteredSpots = _spots;
    } else {
      _filteredSpots = _spots.where((spot) {
        final nameMatches = spot.name?.contains(query) ?? false;
        final stationMatches = spot.nearestStation?.contains(query) ?? false;
        final addressMatches = spot.address?.contains(query) ?? false;
        final subCategoryMatches =
            spot.subcategoryName?.contains(query) ?? false;
        return nameMatches ||
            stationMatches ||
            addressMatches ||
            subCategoryMatches;
      }).toList();
    }

    final locationData = await _locationService.getLocation();
    if (locationData != null) {
      _filteredSpots.sort((a, b) {
        final distanceA = _calculateDistance(locationData.latitude!,
            locationData.longitude!, a.latitude!, a.longitude!);
        final distanceB = _calculateDistance(locationData.latitude!,
            locationData.longitude!, b.latitude!, b.longitude!);
        return distanceA.compareTo(distanceB);
      });
    }

    notifyListeners();
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // π / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  Future<void> fetchSpots(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      // サブカテゴリデータをロード
      await Provider.of<SpotCategoriesSubProvider>(context, listen: false)
          .fetchPlaceCategoriesSub();
      _subCategories =
          Provider.of<SpotCategoriesSubProvider>(context, listen: false)
              .subCategories;

      // スポットデータをロード
      List<Spot> fetchedSpots =
          (await _repository.fetchSpotAllDetails('places'))
              .map((place) => Spot.fromJson(place))
              .toList();
      _spots = fetchedSpots.map((spot) {
        // サブカテゴリの名前をスポットにマッピング
        final subCategory = _subCategories.firstWhere(
          (sub) => sub.categoryId == spot.subcategoryId,
          orElse: () => SpotCategorySub(
              categoryId: -1, name: 'Unknown', parentCategoryId: -1),
        );
        spot.subcategoryName = subCategory.name;
        return spot;
      }).toList();
      _filteredSpots = _spots;
    } catch (e) {
      print('Error fetching spots: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
