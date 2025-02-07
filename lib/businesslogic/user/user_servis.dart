import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class UserService {
  // ユーザー属性を更新するメソッド
  Future<void> updateUserAttribute(
      AuthUserAttributeKey key, String newValue) async {
    try {
      List<AuthUserAttribute> attributes = [
        AuthUserAttribute(userAttributeKey: key, value: newValue)
      ];
      await Amplify.Auth.updateUserAttributes(attributes: attributes);
    } on AuthException catch (e) {
      print('Error updating attribute: ${e.message}');
    }
  }

  // ユーザーを削除するメソッド
  Future<void> deleteUser() async {
    try {
      await Amplify.Auth.deleteUser();
      print('User deleted successfully');
    } catch (e) {
      print('Failed to delete user: $e');
    }
  }
}
