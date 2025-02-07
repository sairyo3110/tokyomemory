import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot_access.dart';
import 'package:mapapp/repository/spot/spot_access.dart';

class PlaceAccessViewModel extends ChangeNotifier {
  final PlaceAccessRepository _repository;
  List<PlaceAccess> _placeAccesses = [];
  bool _isLoading = true;

  PlaceAccessViewModel(this._repository) {
    fetchPlaceAccesses();
  }

  List<PlaceAccess> get placeAccesses => _placeAccesses;
  bool get isLoading => _isLoading;

  Future<void> fetchPlaceAccesses() async {
    print('Fetching place access data...');
    try {
      _placeAccesses = await _repository.fetchPlaceAccesses();
      _placeAccesses = _removeDuplicates(_placeAccesses); // 重複を削除
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Failed to fetch place access data: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  List<PlaceAccess> _removeDuplicates(List<PlaceAccess> accesses) {
    final uniqueAccesses = <String, PlaceAccess>{};
    for (var access in accesses) {
      uniqueAccesses[access.nearestStation] = access;
    }
    return uniqueAccesses.values.toList();
  }
}
