import 'package:flutter/material.dart';
import 'package:mapapp/repository/updart.dart';

class AppVersionController extends ChangeNotifier {
  final AppVersionRepository _repository = AppVersionRepository();
  String? _latestVersion;

  String get latestVersion => _latestVersion ?? "Unknown";

  Future<void> fetchLatestVersion() async {
    _latestVersion = await _repository.fetchLatestVersion();
    notifyListeners(); // UIを更新
  }

  Future<bool> isUpdateAvailable() async {
    await fetchLatestVersion();
    final currentVersion = getCurrentAppVersion();
    final updateAvailable =
        _latestVersion != null && _latestVersion != currentVersion;
    return updateAvailable;
  }

  String getCurrentAppVersion() {
    return "24"; // 実際のアプリバージョンに置き換える
  }
}
