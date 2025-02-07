import 'package:firebase_auth/firebase_auth.dart';
import 'package:mapapp/repository/favorite/favorite_spot.dart';
import 'package:mapapp/repository/spot/spot.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';

class FavoriteService {
  late String userId;
  final SpotRepository spotRepository = SpotRepository();

  Future<bool> isFavorite(String userId, int placeId) async {
    List<int> favorites = await fetchFavorites(userId, '');
    return favorites.contains(placeId);
  }

  Future<bool> toggleFavorite(
      String? userId, int placeId, bool isCurrentlyFavorite) async {
    if (isCurrentlyFavorite) {
      var response = await removeFavorite(userId ?? '', placeId);
      return response.statusCode == 200 ? false : true;
    } else {
      var response = await addFavorite(userId ?? '', placeId);
      return response.statusCode == 200 ? true : false;
    }
  }

  Future<List<int>> fetchUserFavorites() async {
    // ユーザーIDを取得
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    userId = user.uid;

    // ユーザーIDを基にお気に入りスポットのIDリストを取得
    return await fetchFavorites(userId, '');
  }

  Future<Spot?> fetchSpotDetails(int spotId) async {
    try {
      List<dynamic> spotData =
          await spotRepository.fetchSpotAllDetails('places');
      for (var spotJson in spotData) {
        Spot spot = Spot.fromJson(spotJson);
        if (spot.placeId == spotId) {
          return spot;
        }
      }
      return null;
    } catch (e) {
      print('Error fetching spot details: $e');
      return null;
    }
  }

  Future<List<Spot>> fetchFavoriteDetails() async {
    List<int> favoriteIds = await fetchUserFavorites();
    List<Spot> favoriteDetails = [];

    for (int id in favoriteIds) {
      Spot? spot = await fetchSpotDetails(id);
      if (spot != null) {
        favoriteDetails.add(spot);
      }
    }
    return favoriteDetails;
  }
}
