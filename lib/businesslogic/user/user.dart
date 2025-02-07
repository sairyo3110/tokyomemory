import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;
  Map<String, String> _userAttributes = {};

  String? get userId => _userId;
  Map<String, String> get userAttributes => _userAttributes;

  Future<void> loadUserid() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      _userId = authUser.userId;
      await fetchUserAttributes(); // ユーザーIDを取得後にユーザー属性を取得
    } catch (e) {
      print('Error fetching user: $e');
      _userId = null; // ユーザーがサインインしていない場合はnullを設定
    }
    notifyListeners(); // 状態の変更を通知
  }

  Future<void> fetchUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      Map<String, String> attributes = {};
      for (final element in result) {
        String keyName = element.userAttributeKey
            .toString()
            .replaceAll('CognitoUserAttributeKey "', '')
            .replaceAll('"', '');
        attributes[keyName] = element.value;
      }
      _userAttributes = attributes;
    } on AuthException catch (e) {
      print('Error fetching user attributes: ${e.message}');
      _userAttributes = {};
    }
    notifyListeners(); // 状態の変更を通知
  }
}
