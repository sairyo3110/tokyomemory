import 'package:mapapp/test/model/couple.dart';
import 'package:mapapp/test/repositories/couple_repository.dart';

class CoupleService {
  final CoupleRepository coupleRepository;

  CoupleService({required this.coupleRepository});

  Future<void> addCoupleInfo(Couple couple) async {
    try {
      await coupleRepository.addCouple(couple);
    } catch (e) {
      throw Exception('Failed to add couple info: $e');
    }
  }

  Future<void> deleteCoupleInfo(String user1Id) async {
    try {
      await coupleRepository.deleteCouple(user1Id);
    } catch (e) {
      throw Exception('Failed to delete couple info: $e');
    }
  }

  Future<void> updateCoupleInfo(Couple couple) async {
    try {
      await coupleRepository.updateCouple(couple);
    } catch (e) {
      throw Exception('Failed to update couple info: $e');
    }
  }
}
