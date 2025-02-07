import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/repository/spot/spot.dart';

class CouponViewModel with ChangeNotifier {
  final SpotRepository _repository;

  CouponViewModel(this._repository);

  List<Spot> _coupons = [];
  bool _isLoading = true;

  List<Spot> get coupons => _coupons;
  bool get isLoading => _isLoading;

  Future<void> fetchCoupons() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<Spot> fetchedSpots =
          (await _repository.fetchSpotAllDetails('places'))
              .map((place) => Spot.fromJson(place))
              .toList();
      // couponIdがnullでない情報をフィルタリング
      _coupons = fetchedSpots.where((spot) => spot.cCouponId != null).toList();
    } catch (e) {
      print('Error fetching coupons: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
