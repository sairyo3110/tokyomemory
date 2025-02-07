import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/test/model/couple.dart';
import 'package:mapapp/test/model/user.dart';

class UserInfoRepository {
  final String apiUrl =
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/User';

  Future<Map<String, dynamic>> getUser(String firebaseUserId) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        'action': 'get_user',
        'firebase_user_id': firebaseUserId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> outerBody =
          json.decode(utf8.decode(response.bodyBytes));

      final Map<String, dynamic> data = outerBody['body'];

      try {
        final Map<String, dynamic> nestedBody = json.decode(data['body']);

        final UserInfoRDB user = UserInfoRDB.fromJson(nestedBody['user_info']);

        final List<Couple> couples = (nestedBody['couple_info'] as List)
            .map((coupleJson) => Couple.fromJson(coupleJson))
            .toList();

        return {
          'user': user,
          'couples': couples,
        };
      } catch (e) {
        print("Error parsing user info: $e");
        throw Exception('Failed to parse user data');
      }
    } else {
      print("Failed to load data. Status code: ${response.statusCode}");
      throw Exception('Failed to load user data');
    }
  }

  Future<void> addUser(UserInfoRDB userInfo) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        'action': 'add_user',
        'firebase_user_id': userInfo.firebaseUserId,
        'email': userInfo.email,
        'name': userInfo.name,
        'prefecture': userInfo.prefecture,
        'birthday': userInfo.birthday,
        'gender': userInfo.gender,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add user data');
    }
  }

  Future<void> updateUser(UserInfoRDB userInfo) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        'action': 'update_user',
        'firebase_user_id': userInfo.firebaseUserId,
        'name': userInfo.name,
        'prefecture': userInfo.prefecture,
        'birthday': userInfo.birthday,
        'gender': userInfo.gender,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user data');
    }
  }

  Future<void> deleteUser(String firebaseUserId) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        'action': 'delete_user',
        'firebase_user_id': firebaseUserId,
      }),
    );

    print(response.body);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user data');
    }
  }
}
