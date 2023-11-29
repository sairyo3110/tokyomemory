import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mapapp/model/coupon.dart';

class CouponController {
  final String apiUrl =
      "https://kco81ieut7.execute-api.ap-northeast-1.amazonaws.com/MyMap/coupons"; // APIのエンドポイント

  Future<List<Coupon>> fetchCoupons() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<Coupon> coupons = [];
      for (var item in jsonResponse) {
        coupons.add(Coupon.fromJson(item));
      }
      return coupons;
    } else {
      throw Exception('Failed to load coupons');
    }
  }

  Future<List<Coupon>> fetchCouponsByLocation(String location) async {
    Uri uri = Uri.parse('$apiUrl/$location');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body);

      // レスポンスがMap形式の場合、例えばメッセージが返された場合
      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey('message')) {
        return []; // 空のリストを返す
      }

      // レスポンスがList形式の場合
      if (jsonResponse is List<dynamic>) {
        return jsonResponse.map((coupon) => Coupon.fromJson(coupon)).toList();
      }
    }

    throw Exception('Failed to load places by location');
  }
}
