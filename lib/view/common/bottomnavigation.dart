import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/favorite/favorite_plan.dart';
import 'package:mapapp/businesslogic/favorite/favorite_spot.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/date/modeles/plan/plan.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/view/article/article.dart';
import 'package:mapapp/view/carousel/carousel.dart';
import 'package:mapapp/view/coupon/coupon.dart';
import 'package:mapapp/view/coupon/coupon_detail.dart';
import 'package:mapapp/view/profile/profile.dart';
import 'package:mapapp/view/search/plan/plan_detail.dart';
import 'package:mapapp/view/search/search.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mapapp/view/search/spot/spot_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class MainBottomNavigation extends StatefulWidget {
  @override
  _MainBottomNavigationState createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    // アプリが起動している時の初期メッセージを取得
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    // アプリがバックグラウンドから復帰した時のメッセージをリッスン
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  final FavoriteService favoriteService = FavoriteService();
  final PlanFavoriteService _favoriteService = PlanFavoriteService();

  void _handleMessage(RemoteMessage message) async {
    if (message.data['screen'] == 'spot') {
      int spotId = int.parse(message.data['spot']);
      Spot? spotDetail = await favoriteService.fetchSpotDetails(spotId);
      if (spotDetail != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpotDetail(spot: spotDetail),
          ),
        );
      }
    }
    if (message.data['screen'] == 'plan') {
      int planId = int.parse(message.data['plan']);
      Plan? plan = await _favoriteService.fetchPlanDetails(planId);
      if (plan != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanDetail(plan: plan),
          ),
        );
      }
    }
    if (message.data['screen'] == 'article') {
      String url = message.data['url'];
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    if (message.data['screen'] == 'coupon') {
      int spotId = int.parse(message.data['spot']);
      Spot? spotDetail = await favoriteService.fetchSpotDetails(spotId);
      if (spotDetail != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CouponDetail(coupon: spotDetail),
          ),
        );
      }
    }
  }

  void _onItemTapped(int index) async {
    if (_selectedIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
    await FirebaseAnalytics.instance.logEvent(
      name: 'custom_event_with_params',
      parameters: <String, dynamic>{
        'param1': 'value1',
        'param2': 123,
      },
    );
    print('Logged bottom_nav_tap event with index: $index');
  }

  void selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) {
              switch (index) {
                case 0:
                  return CarouselScreen();
                case 1:
                  return SearchScreen();
                case 2:
                  return ArticleScreen();
                case 3:
                  return CouponScreen();
                case 4:
                  return ProfileScreen();
                default:
                  return Container();
              }
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationProvider(
      data: this,
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
            _buildOffstageNavigator(4),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '探す'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: '特集記事'),
            BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number), label: 'クーポン'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'マイページ'),
          ],
          currentIndex: _selectedIndex,
          backgroundColor: Colors.black,
          selectedItemColor: AppColors.onPrimary,
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class NavigationProvider extends InheritedWidget {
  final _MainBottomNavigationState data;

  NavigationProvider({required Widget child, required this.data})
      : super(child: child);

  @override
  bool updateShouldNotify(NavigationProvider oldWidget) => true;

  static _MainBottomNavigationState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavigationProvider>()!.data;
}
