import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';
import 'package:mapapp/view/article/article_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel viewModel;
  late DeepLinkwModel deeolinkModel;
  late final WebViewController controller;

  List<PlanCategory> planCategories = [];
  List<PlaceCategorySub> placeCategories = [];

  final int _current = 0;
  String? userid;

  final ScrollController _scrollController = ScrollController();
  Alignment _alignment = Alignment.centerLeft;
  double _appBarHeight = 80.0;
  double _fontSize = 40.0;

  late DatePlanController datePlanController;

  @override
  void initState() {
    super.initState();

    viewModel = HomeViewModel();
    deeolinkModel = DeepLinkwModel();
    _scrollController.addListener(_onScroll);

    // ディープリンクの初期化
    deeolinkModel.initURIHandler();
    deeolinkModel.initUniLinks();
    viewModel.checkForUpdate();

    deeolinkModel.deepLinkResultStream.listen((DeepLinkResult result) async {
      if (result.type == 'spot') {
        List<PlaceDetail> placeDetails =
            await PlacesProvider().fetchFilteredPlaceDetails([result.id]);

        // 結果のリストから最初の要素を取得（存在する場合）
        if (placeDetails.isNotEmpty) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpotDetailScreen(
                spot: placeDetails.first,
                parentContext: context,
              ),
            ),
          );
        } else {
          // 適切な PlaceDetail が見つからない場合の処理
          print('No place details found for ID: ${result.id}');
        }
      } else if (result.type == 'plan') {
        try {
          // DatePlanController を使用して DatePlan を取得
          DatePlan planDetail =
              await datePlanController.fetchDatePlanById(result.id);
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanDetailScreen(plan: planDetail),
            ),
          );
        } catch (e) {
          print('Error fetching plan details: $e');
        }
      } else if (result.type == 'ivent') {
        try {
          // PlacesProvider を使用して PlaceDetail を取得
          List<PlaceDetail> placeDetails =
              await PlacesProvider().fetchFilteredPlaceDetails([result.id]);
          if (placeDetails.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    IventDetailScreen(spot: placeDetails.first),
              ),
            );
          } else {
            print('No place details found for place ID: ${result.id}');
          }
        } catch (e) {
          print('Error fetching ivent details: $e');
        }
      }
    });

    _loadData();
    _loadUserid();

    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final String _url = 'https://sora-tokyo-dateplan.com/tokyomemory/';
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('アプリ版のお知らせ'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Image.asset('images/Holiday_Tokyo.png'),
                    SizedBox(height: 40),
                    Text('デートをする時に必要な機能が盛りだくさん！'),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(size: 15.0, Icons.task_alt), // Desired icon
                        Text('マップ表示機能', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(size: 15.0, Icons.task_alt), // Desired icon
                        Text('スポット保存機能', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(size: 15.0, Icons.task_alt), // Desired icon
                        Text('クーポン一覧機能', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(size: 15.0, Icons.task_alt), // Desired icon
                        Text('特集記事の表示', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
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
                TextButton(
                  child: Text('Web版を使う'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    deeolinkModel.dispose();
    super.dispose();
  }

  void pushPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Future<void> _loadUserid() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      setState(() {
        userid = authUser.userId;
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<void> _loadData() async {
    var loadedPlanCategories = await viewModel.loadPlanCategories();
    var loadedPlaceCategories = await viewModel.loadPlaceCategories();
    setState(() {
      planCategories = loadedPlanCategories;
      placeCategories = loadedPlaceCategories;
    });
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _appBarHeight = max(50.0, 80.0 - offset);
      _fontSize = max(20.0, 40.0 - offset);
      _alignment = offset > 20.0 ? Alignment.center : Alignment.centerLeft;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'images/Holiday_Tokyo.png',
      'images/Coupon_Banner.png',
      'images/ivites.png',
    ];
    return Scaffold(
      appBar: CustomAppBar(
        height: _appBarHeight,
        alignment: _alignment,
        fontSize: _fontSize,
        titleText: 'Home', // ここに表示したいテキストを指定
      ),
      body: Center(
        child: SingleChildScrollView(
          controller: _scrollController, // ScrollControllerを指定
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (kIsWeb) Image.asset('images/Holiday_Tokyo.png'),
              if (!kIsWeb)
                CarouselComponent(
                  imgList: ['images/Holiday_Tokyo.png', 'images/ivites.png'],
                  onTapItem: (String item) {
                    switch (item) {
                      case 'images/Holiday_Tokyo.png':
                        break;
                      case 'images/ivites.png':
                        // ユーザーIDのチェック
                        if (userid == null) {
                          // ユーザーIDがない場合、ダイアログを表示
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('保存機能を使うには会員登録が必要です。'),
                              content: Text('マイページのログインボタンから会員登録を行ってください。'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // ダイアログを閉じる
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          // ユーザーIDがある場合、InviteCodeScreenにナビゲート
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => InviteCodeScreen(),
                            fullscreenDialog: true,
                          ));
                        }
                        break;
                      default:
                        print('Unknown item tapped');
                    }
                  },
                ),
              if (!kIsWeb)
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
              SpotSearchBox(
                imagePath: 'images/Search_Box.png',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SpotSelectionScreen(),
                    fullscreenDialog: true,
                  ));
                },
              ),
              SizedBox(height: 40),
              if (!kIsWeb)
                SpotSearchBox(
                  imagePath: 'images/map_search.png',
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
              CategorySearchSection(
                placeCategories: placeCategories,
                onCategoryTap: (int categoryId) async {
                  var provider = PlacesProvider();
                  var filteredPlaceIds = await provider.fetchFilteredPlaceIds(
                    selectedLocations: [],
                    minPrice: 0,
                    maxPrice: 200000,
                    selectedCategoryIds: [categoryId],
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpotDisplayScreen(
                        location: '',
                        price: '',
                        category: '$categoryId',
                        filteredPlaceIds: filteredPlaceIds,
                      ),
                    ),
                  );
                },
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
              PlanCardGrid(
                planCategories: planCategories,
                onCategoryTap: (int categoryId) async {
                  DatePlan? relatedDatePlan =
                      await viewModel.fetchDatePlanByCategory(categoryId);
                  if (relatedDatePlan != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlanListScreen(categoryId: categoryId),
                      ),
                    );
                  } else {
                    print("No related DatePlan found for the category.");
                  }
                },
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
}
