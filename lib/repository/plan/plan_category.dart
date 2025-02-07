import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/date/modeles/plan/plan_category.dart';

class PlanCategoryRepository {
  final String apiUrl =
      "https://kco81ieut7.execute-api.ap-northeast-1.amazonaws.com/MyMap/placecategories";

  Future<List<PlanCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((category) => PlanCategory.fromJson(category))
          .toList();
    } else {
      throw Exception('Failed to load categories from Lambda');
    }
  }
}
