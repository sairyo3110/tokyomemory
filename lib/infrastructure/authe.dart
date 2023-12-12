import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class AuthHelper {
  Future<String?> loadUsername() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      return authUser.username;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut(
        options: const SignOutOptions(globalSignOut: true),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<String?> loadUserid() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      return authUser.userId;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<String?> getCurrentUserId() async {
    try {
      var currentUser = await Amplify.Auth.getCurrentUser();
      return currentUser.userId;
    } on AuthException catch (e) {
      print(e);
      return null;
    }
  }
}
