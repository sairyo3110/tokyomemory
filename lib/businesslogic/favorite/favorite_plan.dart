import 'package:firebase_auth/firebase_auth.dart';
import 'package:mapapp/repository/favorite/favorite_plan.dart';
import 'package:mapapp/repository/plan/plan.dart';
import 'package:mapapp/date/modeles/plan/plan.dart';

class PlanFavoriteService {
  late String userId;
  final PlanRepository _planRepository = PlanRepository();

  Future<bool> isFavorite(String? userId, int placeId, String type) async {
    if (userId == null) return false;
    List<int> favorites = await fetchFavoritesplan(userId);
    return favorites.contains(placeId);
  }

  Future<void> toggleFavorite(String? userId, int placeId, String type,
      bool isCurrentlyFavorite) async {
    if (userId == null) return;
    if (isCurrentlyFavorite) {
      await removeFavoriteplan(userId, placeId, type);
    } else {
      await addFavoriteplan(userId, placeId, type);
    }
  }

  Future<List<int>> fetchUserFavoritesPlan() async {
    // ユーザーIDを取得
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    userId = user.uid;

    // ユーザーIDを基にお気に入りプランのIDリストを取得
    return await fetchFavoritesplan(userId);
  }

  Future<Plan?> fetchPlanDetails(int planId) async {
    try {
      List<Plan> plans = await _planRepository.fetchPlans();
      return plans.firstWhere(
        (plan) => plan.planId == planId,
      );
    } catch (e) {
      print('Error fetching plan details: $e');
      return null;
    }
  }
}
