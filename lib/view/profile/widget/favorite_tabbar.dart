// 共通のタブバーウィジェット
import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';

class FavoriteCustomTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController controller;
  final List<Tab> tabs;

  FavoriteCustomTabBar({required this.controller, required this.tabs});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelColor: AppColors.primary, // 選択されたタブの文字色
      unselectedLabelColor: Colors.grey, // 選択されていないタブの文字色
      indicatorColor: AppColors.primary, // インジケータの色
      indicatorWeight: 2.0, // インジケータの太さ
      indicatorPadding: EdgeInsets.symmetric(horizontal: -40), // インジケータのpadding
      labelPadding: EdgeInsets.symmetric(horizontal: 0), // タブの間隔
      tabs: tabs,
    );
  }
}
