import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/model/place.dart';

class PlaceController {
  final String apiUrl =
      "https://kco81ieut7.execute-api.ap-northeast-1.amazonaws.com/MyMap/place"; // Lambda関数のエンドポイントを指定してください。

  Future<List<Place>> fetchPlaces(
      {String? location, String? price, String? category}) async {
    Uri uri = Uri.parse(apiUrl);

    // クエリパラメータを追加
    Map<String, String> queryParams = {};
    if (location != null) queryParams['location'] = location;
    if (price != null) queryParams['price'] = price;
    if (category != null) queryParams['category'] = category;

    uri = uri.replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<List<Place>> fetchPlacesByLocation(String location) async {
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
        return jsonResponse.map((place) => Place.fromJson(place)).toList();
      }
    }

    throw Exception('Failed to load places by location');
  }
}
