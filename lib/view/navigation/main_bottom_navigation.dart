import 'package:flutter/material.dart';
import 'package:mapapp/view/article/article_view.dart';
import 'package:mapapp/view/coupon/coupon_list_screen.dart';
import 'package:mapapp/view/user/profile_settings_screen.dart';
import 'package:mapapp/repository/map_controller_provider.dart';
import 'package:provider/provider.dart';
import '../home/home_screen.dart';

class MainBottomNavigation extends StatefulWidget {
  final Function(int)? onNavigateToTab; // タブへのナビゲーションを管理するためのコールバック

  MainBottomNavigation({Key? key, this.onNavigateToTab}) : super(key: key);

  @override
  _MainBottomNavigationState createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  int _selectedIndex = 0; // 現在選択されているインデックス

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<Widget> _pages = [
    HomeScreen(),
    ArticleView(),
    CouponListScreen(
      category: '',
      location: '',
      price: '',
    ),
    UserInfoScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // 既に選択されているタブをタップした場合、そのタブのメイン画面に戻る
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      // それ以外の場合は、タブを切り替える
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void navigateToTab(int index) {
    if (_navigatorKeys[index].currentState != null) {
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    }
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MapControllerProvider(),
        child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages.map((page) {
              int index = _pages.indexOf(page);
              if (index < _navigatorKeys.length) {
                // GlobalKeyが存在する場合は、Navigatorを使用する
                return Navigator(
                  key: _navigatorKeys[index],
                  onGenerateRoute: (routeSettings) {
                    return MaterialPageRoute(
                      builder: (context) => page,
                    );
                  },
                );
              } else {
                // GlobalKeyが存在しない場合は、Navigatorを使用せずにページを直接返す
                return page;
              }
            }).toList(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'ホーム',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: '特集記事',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number),
                label: 'クーポン',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'マイページ',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFFF6E6DC), // 選択されたアイテムの色
            unselectedItemColor: Colors.grey, // 選択されていないアイテムの色
            onTap: _onItemTapped,
          ),
        ));
  }
}
