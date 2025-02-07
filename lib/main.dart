import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:mapapp/businesslogic/article.dart';
import 'package:mapapp/businesslogic/plan/plan_chategory.dart';
import 'package:mapapp/businesslogic/plan/plan_main.dart';
import 'package:mapapp/businesslogic/spot/spot_access.dart';
import 'package:mapapp/businesslogic/spot/spot_chategory.dart';
import 'package:mapapp/businesslogic/spot/spot_main.dart';
import 'package:mapapp/businesslogic/user/user.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/repository/plan/plan_category.dart';
import 'package:mapapp/repository/spot/spot.dart';
import 'package:mapapp/repository/spot/spot_access.dart';
import 'package:mapapp/service/analytics.dart';
import 'package:mapapp/view/common/bottomnavigation.dart';
import 'package:provider/provider.dart';
import 'businesslogic/coupon/coupon_main.dart';
import 'firebase_options.dart';
import 'package:mapapp/repository/plan/plan.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart' as afs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebaseの初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FCM の通知権限リクエスト
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // FCMトークンの取得
  final token = await messaging.getToken();
  print('🐯 FCM TOKEN: $token');

  // Firebase Messagingのバックグラウンドメッセージハンドラーの登録
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // AppsFlyerの初期化
  afs.AppsFlyerOptions appsFlyerOptions = afs.AppsFlyerOptions(
    afDevKey:
        "GjTTzGQ5bPzFEKsixXxsKg", // Replace with your actual AppsFlyer dev key
    appId: "6466747873", // Replace with your actual AppsFlyer app ID
    showDebug: true,
    timeToWaitForATTUserAuthorization: 50,
    disableAdvertisingIdentifier: true,
    disableCollectASA: true,
  );

  afs.AppsflyerSdk appsflyerSdk = afs.AppsflyerSdk(appsFlyerOptions);

  appsflyerSdk.onAppOpenAttribution((res) {
    print("res: " + res.toString());
  });

  // AppsFlyerのディープリンクコールバック
  appsflyerSdk.onDeepLinking((afs.DeepLinkResult dp) {
    switch (dp.status) {
      case afs.Status.FOUND:
        print(dp.deepLink?.toString());
        print("deep link value: ${dp.deepLink?.deepLinkValue}");
        break;
      case afs.Status.NOT_FOUND:
        print("deep link not found");
        break;
      case afs.Status.ERROR:
        print("deep link error: ${dp.error}");
        break;
      case afs.Status.PARSE_ERROR:
        print("deep link status parsing error");
        break;
    }
  });

  await appsflyerSdk.initSdk(
    registerConversionDataCallback: true,
    registerOnAppOpenAttributionCallback: true,
    registerOnDeepLinkingCallback: true,
  );

  // Firebase Analyticsでアプリ起動イベントをログに記録
  FirebaseLogger logger = FirebaseLogger.instance;
  await logger.logAppOpen();

  // Line SDKの初期化
  await LineSDK.instance.setup("2005805864");
  print("LineSDK 準備完了");

  runApp(MyApp());
}

// Firebase Messagingバックグラウンドメッセージハンドラー
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final FirebaseLogger logger = FirebaseLogger.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SpotViewModel(SpotRepository()),
        ),
        ChangeNotifierProvider(
          create: (context) => PlanViewModel(
              PlanRepository(), SpotRepository(), PlanCategoryRepository()),
        ),
        ChangeNotifierProvider(
          create: (context) => CouponViewModel(SpotRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider()..loadUserid(),
        ),
        ChangeNotifierProvider(
          create: (_) => SpotCategoriesSubProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlanCategoryModel()..fetchPlanCategories(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaceAccessViewModel(PlaceAccessRepository()),
        ),
        ChangeNotifierProvider(create: (_) => ArticleProvider()),
      ],
      child: MaterialApp(
        title: 'MapApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            background: AppColors.primary,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
          ),
        ),
        navigatorObservers: <NavigatorObserver>[logger.observer],
        home: MainBottomNavigation(),
      ),
    );
  }
}
