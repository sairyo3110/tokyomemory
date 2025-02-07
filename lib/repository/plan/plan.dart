import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/date/modeles/plan/plan.dart';

class PlanRepository {
  static const String _endpoint =
      'https://kco81ieut7.execute-api.ap-northeast-1.amazonaws.com/MyMap/dateplans';

  Future<List<Plan>> fetchPlans() async {
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Plan.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load date plans');
    }
  }
}
