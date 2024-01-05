import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/amplifyconfiguration.dart';
import 'package:mapapp/importer.dart';
import 'package:mapapp/view/authenticator/Introslider.dart';
import 'package:mapapp/view/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Amplifyプラグインのインスタンスを作成
  AmplifyAuthCognito authPlugin = AmplifyAuthCognito();

  try {
    // AmplifyにAuthプラグインを追加
    Amplify.addPlugin(authPlugin);

    // Amplifyを設定
    await Amplify.configure(amplifyconfig);
    print('Amplify successfully configured');
  } on AmplifyAlreadyConfiguredException {
    print('Amplify was already configured. Was the app restarted?');
  } on AmplifyException catch (e) {
    print('Could not configure Amplify: ${e.message}');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppVersionController()),
        ChangeNotifierProvider(create: (context) => MapControllerProvider()),
        ChangeNotifierProvider(create: (context) => PlacesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF444440),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFF6E6DC)),
        ),
      ),
      home: kIsWeb ? HomeScreen() : IntroSliderScreen(),
      builder: (context, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: kIsWeb ? DownloadBanner() : null, // Webの場合のみ表示
        );
      },
    );
  }
}

class DownloadBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textWidth = screenWidth * 0.6; // 画面幅の80%を使用
    final String _url = 'https://sora-tokyo-dateplan.com/tokyomemory/';
    return Container(
      padding: EdgeInsets.all(16),
      color: Color(0xFFF6E6DC),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: textWidth,
            child: Text(
              'マップ表示や保存機能などデートをする時に必要な機能盛りだくさん！',
              style: TextStyle(color: Color(0xFF444440)),
            ),
          ),
          ElevatedButton(
            child: Text('ダウンロード'),
            onPressed: () async {
              if (await canLaunch(_url)) {
                await launch(_url);
              } else {
                // リンクを開くことができない場合の処理
                print('Could not launch $_url');
              }
            },
          ),
        ],
      ),
    );
  }
}
