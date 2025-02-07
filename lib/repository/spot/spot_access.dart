import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/date/modeles/spot/spot_access.dart';

class PlaceAccessRepository {
  final String _baseUrl =
      'https://r1ahdkatn2.execute-api.ap-northeast-1.amazonaws.com/mymap/tables/PlaceAccess';

  Future<List<PlaceAccess>> fetchPlaceAccesses() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> outerBody = json.decode(responseBody);

      if (outerBody.containsKey('body')) {
        Map<String, dynamic> innerBody = outerBody['body'];

        if (innerBody.containsKey('body')) {
          List<dynamic> bodyData = json.decode(innerBody['body']);

          return bodyData.map((place) => PlaceAccess.fromJson(place)).toList();
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Invalid response structure');
      }
    } else {
      throw Exception('Failed to load place access data');
    }
  }
}
