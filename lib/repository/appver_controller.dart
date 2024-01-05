import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppVersionController extends ChangeNotifier {
  String? _latestVersion;
  String get latestVersion => _latestVersion ?? "Unknown";

  // Lambdaから最新バージョンを取得する関数
  Future<void> fetchLatestVersion() async {
    final url =
        'https://kco81ieut7.execute-api.ap-northeast-1.amazonaws.com/MyMap/appver';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          _latestVersion = data['body'] != null
              ? json.decode(data['body'])['latest_version']
              : null;
          print('Fetched latest version: $_latestVersion'); // 追加：デバッグ出力
        } else {
          print('Incorrect JSON format');
        }
        notifyListeners(); // Notify listeners to update the UI
      } else {
        print(
            'Failed to fetch latest version: ${response.statusCode}'); // 追加：デバッグ出力
      }
    } catch (e) {
      print('Exception caught while fetching version: $e'); // 追加：デバッグ出力
    }
  }

  // アップデートが利用可能かどうかを判断する関数
  Future<bool> isUpdateAvailable() async {
    final currentVersion = getCurrentAppVersion();
    print('Current version: $currentVersion'); // 追加：デバッグ出力
    await fetchLatestVersion();
    final updateAvailable =
        _latestVersion != null && _latestVersion != currentVersion;
    print('Is update available? $updateAvailable'); // 追加：デバッグ出力
    return updateAvailable;
  }

  // 現在のアプリバージョンを取得する関数を修正
  String getCurrentAppVersion() {
    // ここでpubspec.yamlに記載のバージョンを返すと仮定しています。
    // 実際のアプリでは、pubspec.yamlからバージョンを読み取るか、
    // 手動で更新する必要があります。
    return "17";
  }
}
