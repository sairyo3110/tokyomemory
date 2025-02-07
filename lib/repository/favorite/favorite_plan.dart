import 'package:http/http.dart' as http;
import 'dart:convert';

// お気に入りを追加する
Future<http.Response> addFavoriteplan(
    String userId, int placeId, String type) async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/planfavorites');

  var body = {
    'user_id': userId,
    'place_id': placeId,
    'type': type, // 追加：お気に入りのタイプ (spot または plan)
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
Future<http.Response> removeFavoriteplan(
    String userId, int placeId, String type) async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/planfavorites');

  var body = {
    'user_id': userId,
    'place_id': placeId,
    'type': type, // 追加：お気に入りのタイプ (spot または plan)
    'action': 'remove_favorite',
  };
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  return response;
}

Future<List<int>> fetchFavoritesplan(String userId) async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/planfavorites');

  var body = {
    'user_id': userId,
    'type': 'plan', // 特定のタイプのお気に入りを指定
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
    if (favorite['type'] == 'plan') {
      // タイプが 'plan' のみを追加
      favoriteIds.add(favorite['place_id']);
    }
  }

  return favoriteIds;
}

// 全てのお気に入りリストを取得する
Future<http.Response> fetchAllFavoritesplan() async {
  final url = Uri.parse(
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/planfavorites');

  var response = await http.get(
    url,
    headers: {"Content-Type": "application/json"},
  );

  return response;
}
