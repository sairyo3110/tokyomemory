import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapapp/component/user_profile_dialog.dart';
import 'package:mapapp/model/plan.dart';
import 'package:mapapp/model/plan_category%20copy.dart';
import 'package:mapapp/repository/appver_controller.dart';
import 'package:mapapp/repository/date_plan_controller.dart';
import 'package:mapapp/repository/plan_category_controller.dart';
import 'package:mapapp/test/PlaceChategories.dart';
import 'package:mapapp/test/places_provider.dart';
import 'package:mapapp/test/rerated_model.dart';
import 'package:mapapp/view/coupon/coupon_list_screen.dart';
import 'package:mapapp/view/ivent/ivent_detail_screen.dart';
import 'package:mapapp/view/plan/plan_detail_screenrealy.dart';
import 'package:mapapp/view/spot/spot_detail_screen.dart';
import 'package:mapapp/view/user/Invite.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../plan/plan_list_screen.dart';
import '../spot/spot_display_screen.dart';
import '../spot/spot_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PlanCategory> planCategories = [];
  List<PlaceCategory> placeCategories = [];
  Map<String, String> userAttributes = {};

  late final WebViewController controller;

  int _current = 0;

  final ScrollController _scrollController = ScrollController();
  Alignment _alignment = Alignment.centerLeft;
  double _appBarHeight = 80.0;
  double _fontSize = 40.0;

  StreamSubscription? _sub;

  late DatePlanController datePlanController;

// ローディング状態を追跡するための変数

  @override
  void initState() {
    super.initState();
    datePlanController = DatePlanController();
    initUniLinks();
    initURIHandler();
    _determinePosition();
    _scrollController.addListener(_onScroll);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://sora-tokyo-dateplan.com/'));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
      loadPlanCategories(); // Add this line
      loadPlaceCategories(); // Add this line
      fetchCurrentUserAttributes();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose(); // ScrollControllerをクリーンアップ
    super.dispose();
    print('HomePage dispose()');
  }

  // アプリ開始時に初期URIを取得
  Future<void> initURIHandler() async {
    try {
      final Uri? initialURI = await getInitialUri();
      print('Initial URI: $initialURI');
      // 初期URIに基づいて必要なアクションを実行
      if (initialURI != null) {
        handleDeepLink(initialURI);
      }
    } on PlatformException {
      debugPrint("Failed to receive initial uri");
    }
  }

  // DeepLinkを監視する
  Future<void> initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) {
      print('New link: $uri');
      if (uri != null) {
        handleDeepLink(uri);
      }
    }, onError: (err) {
      debugPrint('Error occurred: $err');
    });
  }

  // URIに基づいて適切なページに遷移
  // _HomeScreenState クラス内の handleDeepLink メソッド
  void handleDeepLink(Uri uri) async {
    print('Received deep link: $uri');

    final host = uri.host;
    final pathSegments = uri.pathSegments;
    print('Handling deep link with host: $host, path: $pathSegments');

    if (host == 'spot' && pathSegments.isNotEmpty) {
      final String spotIdString = pathSegments.first;
      print('Spot ID from the deep link: $spotIdString');

      final int? spotId = int.tryParse(spotIdString);
      print('Parsed spot ID: $spotId');

      if (spotId != null) {
        try {
          print('Attempting to fetch spot details for ID: $spotId');
          PlacesProvider provider = PlacesProvider(context);
          List<PlaceDetail> placeDetails =
              await provider.fetchFilteredPlaceDetails([spotId]);
          print('Fetched place details: $placeDetails');

          if (placeDetails.isNotEmpty) {
            PlaceDetail placeDetail = placeDetails.first;
            print(
                'Navigating to SpotDetailScreen with placeDetail: $placeDetail');
            pushPage(SpotDetailScreen(spot: placeDetail));
          } else {
            print('No matching spot found for ID: $spotId');
          }
        } catch (e) {
          print('Error fetching place details: $e');
        }
      } else {
        print('Invalid spot ID: $spotIdString');
      }
    } else if (host == 'plan' && pathSegments.isNotEmpty) {
      final String planIdString = pathSegments.first;
      final int? planId = int.tryParse(planIdString);

      if (planId != null) {
        try {
          // `datePlanController` を使ってメソッドを呼び出します。
          DatePlan planDetail =
              await datePlanController.fetchDatePlanById(planId);
          pushPage(PlanDetailScreen(plan: planDetail));
        } catch (e) {
          print('Error fetching plan details: $e');
        }
      } else {
        print('Invalid plan ID: $planIdString');
      }
    } else if (host == 'ivent' && pathSegments.isNotEmpty) {
      final String placeIdString = pathSegments.first;
      print('Place ID from the deep link: $placeIdString');

      final int? placeId = int.tryParse(placeIdString);
      print('Parsed place ID: $placeId');

      if (placeId != null) {
        try {
          print('Attempting to fetch ivent details for ID: $placeId');
          PlacesProvider provider = PlacesProvider(context);
          List<PlaceDetail> placeDetails =
              await provider.fetchFilteredPlaceDetails([placeId]);
          if (placeDetails.isNotEmpty) {
            PlaceDetail placeDetail = placeDetails.first;
            pushPage(IventDetailScreen(spot: placeDetail));
          } else {
            print('No place details found for place ID: $placeId');
          }
        } catch (e) {
          print('Error fetching ivent details: $e');
        }
      } else {
        print('Invalid place ID: $placeIdString');
      }
    } else {
      print('Unknown host: $host');
    }
  }

  void pushPage(Widget page) {
    print('Pushing page: $page');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _appBarHeight = max(50.0, 80.0 - offset); // スクロールに応じてAppBarの高さを変更
      _fontSize = max(20.0, 40.0 - offset); // スクロールに応じてフォントサイズを変更
      if (offset > 20.0) {
        // 20.0は適当な閾値、実際には適切な値を設定する必要があります
        _alignment = Alignment.center; // スクロールが一定量進んだらセンターに配置
      } else {
        _alignment = Alignment.centerLeft; // それ以外の場合は左寄せ
      }
    });
  }

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Here you could add some user-friendly error handling
      print('Could not launch $url');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open the link. Please try again later.'),
        ),
      );
    }
  }

  Future<void> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      Map<String, String> attributes = {};
      for (final element in result) {
        String keyName = element.userAttributeKey
            .toString()
            .replaceAll('CognitoUserAttributeKey "', '')
            .replaceAll('"', '');
        attributes[keyName] = element.value;
      }
      setState(() {
        userAttributes = attributes;
      });

      // Check if user has filled in birthday, prefecture, and gender
      if (attributes["birthdate"] == null ||
          attributes["address"] ==
              null || // Assuming 'custom:prefecture' is the key for prefecture. Adjust if necessary.
          attributes["gender"] == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              UserProfileUpdateDialog(parentContext: context),
        );
      }
    } on AuthException catch (e) {
      print('Error fetching user attributes: ${e.message}');
    }
  }

  Future<void> _checkForUpdate() async {
    final appVersionController =
        context.read<AppVersionController>(); // この行は変更なし
    final isUpdateAvailable = await appVersionController.isUpdateAvailable();
    if (isUpdateAvailable) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            UpdatePromptDialog(updateRequestType: UpdateRequestType.cancelable),
      );
    }
  }

  // LambdaからPlanCategoryを非同期に取得する関数
  Future<void> loadPlanCategories() async {
    try {
      List<PlanCategory> fetchedCategories =
          await PlanCategoryController().fetchCategories();
      setState(() {
        planCategories = fetchedCategories;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> loadPlaceCategories() async {
    try {
      var provider = PlacesProvider(context); // PlacesProvider のインスタンスを作成
      var categories =
          await provider.fetchPlaceCategories(); // fetchPlaceCategories を呼び出す
      setState(() {
        placeCategories = categories;
      });
    } catch (e) {
      print("Error fetching place categories: $e");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'images/Holiday_Tokyo.png',
      'images/Coupon_Banner.png',
      'images/ivites.png',
    ];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_appBarHeight), // AppBarの縦幅を100.0に設定
        child: AppBar(
          title: Container(
            padding: EdgeInsets.all(8.0), // 余白を追加
            alignment: _alignment, // alignmentを動的に設定
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.0), // 上に10.0の余白を追加
                Text(
                  'Home',
                  style: TextStyle(
                    color: Color(0xFFF6E6DC),
                    fontSize: _fontSize, // 文字サイズを40.0に設定
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          elevation: 0, // 影を消す
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          controller: _scrollController, // ScrollControllerを指定
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                    height: 250,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                items: imgList
                    .map(
                      (item) => GestureDetector(
                        onTap: () {
                          switch (item) {
                            case 'images/Holiday_Tokyo.png':
                              break;
                            case 'images/Coupon_Banner.png':
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CouponListScreen(
                                  category: '',
                                  location: '',
                                  price: '',
                                ),
                                fullscreenDialog: true,
                              ));
                              break;
                            case 'images/ivites.png':
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InviteCodeScreen(),
                                fullscreenDialog: true,
                              ));
                              break;
                            default:
                              print('Unknown item tapped');
                          }
                        },
                        child: Container(
                          child: Center(
                            child: Image.asset(item,
                                fit: BoxFit.cover, width: 1000),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.map((url) {
                  int index = imgList.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
              Container(
                padding: EdgeInsets.all(20.0), // 余白を追加
                alignment: Alignment.centerLeft, // 左寄せ
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0), // 上に10.0の余白を追加
                    Text(
                      'スポットを探す',
                      style: TextStyle(
                        color: Color(0xFFF6E6DC),
                        fontSize: 25, // 文字サイズを40.0に設定
                        fontWeight: FontWeight.w900, // ここを変更
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SpotSelectionScreen(),
                    fullscreenDialog: true,
                  ));
                },
                child: Image.asset(
                  'images/Search_Box.png',
                  width: 310,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SpotDisplayScreen(
                      showMap: true,
                      category: '',
                      location: '',
                      price: '',
                    ),
                  ));
                },
                child: Container(
                  width: 320,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // 枠の色
                      width: 1.5, // 枠の太さ
                    ),
                    borderRadius: BorderRadius.circular(12), // ここで角の半径を設定
                  ),
                  child: ClipRRect(
                    // このウィジェットで画像の角を丸くする
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'images/Map.png',
                      width: 325,
                      fit: BoxFit.cover, // 画像がContainerにフィットするように設定
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                'カテゴリから検索',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 180.0,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 15.0),
                  scrollDirection: Axis.horizontal, // 横方向にスクロールさせる
                  itemCount: placeCategories.length,
                  itemBuilder: (context, index) {
                    String categoryName = placeCategories[index].name;
                    String imageUrl =
                        'https://mymapapp.s3.ap-northeast-1.amazonaws.com/PlaceChategori/${placeCategories[index].name}/1.jpg'; //
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SpotDisplayScreen(
                            category:
                                placeCategories[index].categoryId.toString(),
                            location: '', // 適切な位置情報を設定してください
                            price: '', // 適切な価格範囲を設定してください
                          ),
                        ));
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(right: 15.0), // 項目と項目の間にスペースを追加
                        child: Column(
                          children: [
                            Container(
                              width: 130.0,
                              height: 130.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(categoryName),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 50),
              Container(
                padding: EdgeInsets.all(20.0), // 余白を追加
                alignment: Alignment.centerLeft, // 左寄せ
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0), // 上に10.0の余白を追加
                    Text(
                      'デートプランを立てる',
                      style: TextStyle(
                        color: Color(0xFFF6E6DC),
                        fontSize: 25, // 文字サイズを40.0に設定
                        fontWeight: FontWeight.w900, // ここを変更
                      ),
                    ),
                  ],
                ),
              ),
              buildPlanCardGrid(),
              Container(
                padding: EdgeInsets.all(20.0), // 余白を追加
                alignment: Alignment.centerLeft, // 左寄せ
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0), // 上に10.0の余白を追加
                    Text(
                      'お知らせ',
                      style: TextStyle(
                        color: Color(0xFFF6E6DC),
                        fontSize: 25, // 文字サイズを40.0に設定
                        fontWeight: FontWeight.w900, // ここを変更
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'images/update.png',
                width: 350,
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPlanCardGrid() {
    return Container(
      height: 350,
      child: GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: planCategories.length,
        itemBuilder: (context, index) {
          String imageUrl =
              'https://mymapapp.s3.ap-northeast-1.amazonaws.com/PlanChategori/${planCategories[index].name}/1.jpg';
          return GestureDetector(
            onTap: () async {
              DatePlan? relatedDatePlan =
                  await fetchDatePlanByCategory(planCategories[index].id);
              if (relatedDatePlan != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PlanListScreen(categoryId: planCategories[index].id),
                  ),
                );
              } else {
                print("No related DatePlan found for the category.");
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      '${planCategories[index].name}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<DatePlan?> fetchDatePlanByCategory(int categoryId) async {
    DatePlanController controller = DatePlanController();
    List<DatePlan> allDatePlans = await controller.fetchDatePlans();
    for (var datePlan in allDatePlans) {
      if (datePlan.planCategoryId == categoryId) {
        return datePlan;
      }
    }
    return null;
  }

  Future<String?> getCurrentUserId() async {
    try {
      var currentUser =
          await Amplify.Auth.getCurrentUser(); // Amplifyをインポートする必要があります
      return currentUser.userId;
    } on AuthException catch (e) {
      // AuthExceptionをインポートする必要があります
      print(e);
      return null;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 位置情報サービスが有効かどうかをテスト
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 位置情報サービスが無効の場合は、ユーザーに位置情報サービスを有効にするよう促す
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // パーミッションが拒否された場合は、エラーを返す
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // パーミッションが永久に拒否された場合は、設定メニューへの誘導を促す
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // 位置情報の取得
    return await Geolocator.getCurrentPosition();
  }
}

class UpdatePromptDialog extends StatelessWidget {
  final UpdateRequestType? updateRequestType;

  const UpdatePromptDialog({Key? key, required this.updateRequestType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // プラットフォームに応じたアップデートURLを設定
    final String updateUrl = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=tokyomemory.mapapp0918&pli=1'
        : 'https://apps.apple.com/jp/app/tokyo-memory/id6466747873';

    return WillPopScope(
      onWillPop: () async =>
          updateRequestType ==
          UpdateRequestType.cancelable, // キャンセル可能な場合には戻る操作を有効にする
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

enum UpdateRequestType { mandatory, cancelable }
