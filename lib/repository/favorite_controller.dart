import 'package:http/http.dart' as http;
import 'dart:convert';

// お気に入りを追加する
Future<http.Response> addFavorite(String userId, int placeId) async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/favorites');

  var body = {
    'user_id': userId,
    'place_id': placeId,
    'action': 'add_favorite',
  };
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  return response;
}

// お気に入りを削除する
Future<http.Response> removeFavorite(String userId, int placeId) async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/favorites');

  var body = {
    'user_id': userId,
    'place_id': placeId,
    'action': 'remove_favorite',
  };
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  return response;
}

Future<List<int>> fetchFavorites(String userId) async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/favorites');

  var body = {
    'user_id': userId,
    'action': 'get_favorites',
  };

  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  String responseBody = utf8.decode(response.bodyBytes);
  Map<String, dynamic> outerBody = json.decode(responseBody);
  Map<String, dynamic> innerBody = outerBody['body'];
  Map<String, dynamic> favoriteBody = json.decode(innerBody['body']);
  List<dynamic> favorites = favoriteBody['favorites'];

  List<int> favoriteIds = [];
  for (var favorite in favorites) {
    favoriteIds.add(favorite['place_id']); // int.parseを削除
  }

  return favoriteIds;
}

// 全てのお気に入りリストを取得する
Future<http.Response> fetchAllFavorites() async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/favorites');

  var response = await http.get(
    url,
    headers: {"Content-Type": "application/json"},
  );

  return response;
}
