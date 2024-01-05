import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';

enum UpdateRequestType { mandatory, cancelable }

class UpdatePromptDialog extends StatelessWidget {
  final UpdateRequestType updateRequestType;
  final String androidUpdateUrl;
  final String iosUpdateUrl;

  const UpdatePromptDialog({
    Key? key,
    required this.updateRequestType,
    this.androidUpdateUrl =
        'https://play.google.com/store/apps/details?id=your.android.package',
    this.iosUpdateUrl = 'https://apps.apple.com/app/your-ios-app-id',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // プラットフォームに応じたアップデートURLを設定
    final String updateUrl =
        Platform.isAndroid ? androidUpdateUrl : iosUpdateUrl;

    return WillPopScope(
      onWillPop: () async => updateRequestType == UpdateRequestType.cancelable,
      child: CupertinoAlertDialog(
        title: Text('アプリが更新されました。\n\n最新バージョンのダウンロードをお願いします。'),
        actions: <Widget>[
          if (updateRequestType == UpdateRequestType.cancelable)
            TextButton(
              child: Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          TextButton(
            child: Text('アップデートする'),
            onPressed: () => launch(updateUrl),
          ),
        ],
      ),
    );
  }
}
