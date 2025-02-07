import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotRepository {
  final String _baseUrl =
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap';

  Future<List<dynamic>> fetchSpotAllDetails(String endpoint,
      {String? keyword}) async {
    String url;
    switch (endpoint) {
      case 'places':
        url = '$_baseUrl/places';
        break;
      case 'coupons':
        url = '$_baseUrl/coupons';
        break;
      case 'search':
        url = '$_baseUrl/places/$keyword';
        break;
      default:
        throw Exception('Invalid endpoint');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      Map<String, dynamic> outerBody = json.decode(responseBody);

      // 修正: innerBody を Map<String, dynamic> として取得
      Map<String, dynamic> innerBody = outerBody['body'];

      // 修正: innerBody の 'body' キーの値（文字列）を再度デコード
      List<dynamic> bodyData = json.decode(innerBody['body']);
      return bodyData;
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<List<dynamic>> fetchPlaceCategories() async {
    final url = '$_baseUrl/tables/PlaceCategories';
    return _fetchData(url);
  }

  Future<List<dynamic>> fetchPlaceCategoriesSub() async {
    final url = '$_baseUrl/tables/PlaceCategoriesSub';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      Map<String, dynamic> outerBody = json.decode(responseBody);

      // innerBody を Map<String, dynamic> として取得
      Map<String, dynamic> innerBody = outerBody['body'];

      // innerBody の 'body' キーの値（文字列）を再度デコード
      List<dynamic> bodyData = json.decode(innerBody['body']);
      return bodyData;
    } else {
      throw Exception(
          'Unexpected data format: bodyData is not a List<dynamic>');
    }
  }

  Future<List<dynamic>> _fetchData(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> outerBody = json.decode(responseBody);
      List<dynamic> bodyData = json.decode(outerBody['body']);
      return bodyData;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
