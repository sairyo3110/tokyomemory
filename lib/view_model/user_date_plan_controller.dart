import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/model/user_date_plan.dart';

class UserDatePlanController {
  final String apiUrl;

  UserDatePlanController({required this.apiUrl});

  Future<bool> createUserDatePlan(UserDatePlan plan) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(plan.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
