import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/model/plan.dart';

class DatePlanController {
  static const String _endpoint =
      'https://kco81ieut7.execute-api.ap-northeast-1.amazonaws.com/MyMap/dateplans';

  Future<List<DatePlan>> fetchDatePlans() async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => DatePlan.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load date plans');
    }
  }

  Future<DatePlan> fetchDatePlanById(int planId) async {
    List<DatePlan> allPlans = await fetchDatePlans();
    try {
      // `firstWhere` は見つからない場合に例外を投げます。
      return allPlans.firstWhere((p) => p.planId == planId);
    } catch (e) {
      // 見つからない場合のエラーを投げます。
      throw Exception('Plan with id $planId not found');
    }
  }

  Future<List<DatePlan>> fetchDatePlansByCategory(int categoryId) async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<DatePlan> plans =
          jsonResponse.map((data) => DatePlan.fromJson(data)).toList();
      // カテゴリIDに基づいてフィルタリング
      return plans.where((plan) => plan.planCategoryId == categoryId).toList();
    } else {
      throw Exception('Failed to load date plans');
    }
  }
}
