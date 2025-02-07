import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';

class CarouselTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<Tab> tabs;

  CarouselTabBar({required this.controller, required this.tabs});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelColor: AppColors.onPrimary, // 選択されたタブの文字色
      unselectedLabelColor: Colors.grey, // 選択されていないタブの文字色
      indicator: BoxDecoration(), // インジケータを非表示にする
      dividerColor: Colors.transparent, // タブ間の境界線を非表示にする
      tabs: tabs,
    );
  }
}
