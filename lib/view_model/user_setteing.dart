import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:mapapp/importer.dart';

class UserSettingModel {
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
