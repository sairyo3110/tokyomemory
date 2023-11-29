import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/model/clickinfo2.dart';

class ClickInfo2Controller {
  static const String _endpoint =
      'https://kco81ieut7.execute-api.ap-northeast-1.amazonaws.com/MyMap/clicksinfo'; // ここにAPI GatewayのURLを入力してください。

  Future<void> saveClickInfo2(ClickInfo2 clickInfo2) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(clickInfo2.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save click info. Error: ${response.body}');
    }
  }
}
