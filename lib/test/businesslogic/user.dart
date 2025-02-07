import 'package:mapapp/test/model/couple.dart';
import 'package:mapapp/test/model/user.dart';
import 'package:mapapp/test/repositories/user_repository.dart';

class UserInfoService {
  final UserInfoRepository userInfoRepository;

  UserInfoService({required this.userInfoRepository});

  Future<Map<String, dynamic>> fetchUserInfo(String firebaseUserId) async {
    try {
      final data = await userInfoRepository.getUser(firebaseUserId);
      final user = data['user'] as UserInfoRDB;
      final couples = data['couples'] as List<Couple>;

      return {
        'user': user,
        'couples': couples,
      };
    } catch (e) {
      throw Exception('Failed to fetch user info: $e');
    }
  }

  Future<void> addUserInfo(UserInfoRDB userInfo) async {
    try {
      await userInfoRepository.addUser(userInfo);
    } catch (e) {
      throw Exception('Failed to add user info: $e');
    }
  }

  Future<void> updateUserInfo(UserInfoRDB userInfo) async {
    try {
      await userInfoRepository.updateUser(userInfo);
    } catch (e) {
      throw Exception('Failed to update user info: $e');
    }
  }

  Future<void> deleteUserInfo(String firebaseUserId) async {
    try {
      await userInfoRepository.deleteUser(firebaseUserId);
    } catch (e) {
      throw Exception('Failed to delete user info: $e');
    }
  }
}
