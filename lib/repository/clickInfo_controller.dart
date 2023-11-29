import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapapp/model/clickinfo.dart';

class ClickInfoController {
  static const String _endpoint =
      'https://kco81ieut7.execute-api.ap-northeast-1.amazonaws.com/MyMap/userclicks'; // ここにAPI GatewayのURLを入力してください。

  Future<void> saveClickInfo(ClickInfo clickInfo) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(clickInfo.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save click info. Error: ${response.body}');
    }
  }
}
