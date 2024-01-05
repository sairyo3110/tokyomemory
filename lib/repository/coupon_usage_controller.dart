import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/model/coupon_usage.dart';

class CouponUsageController {
  final String _endpoint =
      'https://kco81ieut7.execute-api.ap-northeast-1.amazonaws.com/MyMap/couponusage';

  Future<void> sendCouponUsage(CouponUsage usage) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usage.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to send coupon usage to the API: ${response.body}');
    }
  }

  Future<List<CouponUsage>> getCouponUsages() async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body);
      return responseBody.map((json) => CouponUsage.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to fetch coupon usages from the API: ${response.body}');
    }
  }
}
