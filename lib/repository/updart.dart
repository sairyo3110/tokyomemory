import 'dart:convert';
import 'package:http/http.dart' as http;

class AppVersionRepository {
  Future<String?> fetchLatestVersion() async {
    const url =
        'https://kco81ieut7.execute-api.ap-northeast-1.amazonaws.com/MyMap/appver';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          final latestVersion = data['body'] != null
              ? json.decode(data['body'])['latest_version']
              : null;
          return latestVersion;
        }
      }
    } catch (e) {
      print('Exception caught while fetching version: $e');
    }
    return null;
  }
}
