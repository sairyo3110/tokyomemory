import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/test/model/couple.dart';

class CoupleRepository {
  final String apiUrl =
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/User';

  Future<void> addCouple(Couple couple) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        'action': 'add_couple',
        'user1_id': couple.user1Id,
        'user2_id': couple.user2Id,
        'anniversary_date': couple.anniversaryDate,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add couple data');
    }
  }

  Future<void> deleteCouple(String user1Id) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        'action': 'delete_couple',
        'user1_id': user1Id,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete couple data');
    }
  }

  Future<void> updateCouple(Couple couple) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        'action': 'update_couple',
        'couple_id': couple.coupleId,
        'anniversary_date': couple.anniversaryDate,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update couple data');
    }
  }
}
