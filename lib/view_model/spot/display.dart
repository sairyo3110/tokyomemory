import 'package:mapapp/importer.dart';

class SpotDisplayViewModel with ChangeNotifier {
  final PlacesProvider placesProvider;
  List<PlaceDetail> spots = [];
  List<PlaceDetail> filteredSpots = [];
  bool isDataLoaded = false;
  Position? yourLocation;

  SpotDisplayViewModel({required this.placesProvider});

  void fetchAllPlaces(String endpoint) {
    placesProvider.fetchPlaceAllDetails(endpoint).then((data) {
      List<PlaceDetail> spotsWithCoupons = [];
      List<PlaceDetail> spotsWithoutCoupons = [];

      for (var spot in data) {
        if (spot.cCouponId != null && spot.cCouponId! > 0) {
          spotsWithCoupons.add(spot);
        } else {
          spotsWithoutCoupons.add(spot);
        }
      }

      spotsWithCoupons
          .sort((a, b) => calculateDistance(a).compareTo(calculateDistance(b)));
      spotsWithoutCoupons
          .sort((a, b) => calculateDistance(a).compareTo(calculateDistance(b)));

      spots
        ..clear()
        ..addAll(spotsWithCoupons)
        ..addAll(spotsWithoutCoupons);
      isDataLoaded = true;
      filterSpots();
      notifyListeners();
    }).catchError((error) {
      print('Error fetching places: $error');
    });
  }

  void fetchFilteredPlaces(List<int> placeIds) {
    placesProvider.fetchFilteredPlaceDetails(placeIds).then((data) {
      List<PlaceDetail> spotsWithCoupons = [];
      List<PlaceDetail> spotsWithoutCoupons = [];

      for (var spot in data) {
        if (spot.cCouponId != null && spot.cCouponId! > 0) {
          spotsWithCoupons.add(spot);
        } else {
          spotsWithoutCoupons.add(spot);
        }
      }

      spotsWithCoupons
          .sort((a, b) => calculateDistance(a).compareTo(calculateDistance(b)));
      spotsWithoutCoupons
          .sort((a, b) => calculateDistance(a).compareTo(calculateDistance(b)));

      spots
        ..clear()
        ..addAll(spotsWithCoupons)
        ..addAll(spotsWithoutCoupons);
      isDataLoaded = true;
      filterSpots();
      notifyListeners();
    }).catchError((error) {
      print('Error fetching filtered places: $error');
    });
  }

  double calculateDistance(PlaceDetail place) {
    if (yourLocation == null || place.address!.isEmpty) {
      return double.maxFinite;
    }

    double lat1 = yourLocation!.latitude;
    double lon1 = yourLocation!.longitude;
    double? lat2 = place.paLatitude;
    double? lon2 = place.paLongitude;

    double distance = Geolocator.distanceBetween(lat1, lon1, lat2!, lon2!);
    return distance;
  }

  void filterSpots() {
    filteredSpots.clear();

    for (var spot in spots) {
      bool categoryMatch = true; // ここでカテゴリーマッチのロジックを実装
      bool locationMatch = true; // ここでロケーションマッチのロジックを実装
      bool priceMatch = true; // ここで価格マッチのロジックを実装

      if (categoryMatch && locationMatch && priceMatch) {
        filteredSpots.add(spot);
      }
    }

    notifyListeners();
  }
}
