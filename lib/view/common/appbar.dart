import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/view/search/searchbox/search_box.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton; // 戻るボタンを表示するかどうかのフラグ
  final bool showTitle; // タイトルを表示するかどうかのフラグ
  final bool showSearchBox; // 検索ボックスを表示するかどうかのフラグ
  final bool showToggleButton; // アイコンボタンを表示するかどうかのフラグ
  final VoidCallback? onToggleButtonPressed; // アイコンボタンが押された時のコールバック
  final bool isMapView; // 現在のビューがマップビューかどうか
  final VoidCallback? onBackButtonPressed; // 戻るボタンが押された時のコールバック
  final bool showEditButton; // プロフィール編集ボタンの表示非表示フラグ
  final VoidCallback? onEditButtonPressed; // プロフィール編集ボタンが押された時のコールバック
  final bool showSettingsButton; // 設定ボタンの表示非表示フラグ
  final VoidCallback? onSettingsButtonPressed; // 設定ボタンが押された時のコールバック
  final bool showSearchBackButton; // 検索ボックスの戻るボタンの表示非表示フラグ

  CustomAppBar({
    required this.title,
    this.showBackButton = false, // デフォルトは表示しない
    this.showTitle = true, // デフォルトは表示する
    this.showSearchBox = false, // デフォルトは表示しない
    this.showToggleButton = false, // デフォルトは表示しない
    this.onToggleButtonPressed,
    this.isMapView = false, // デフォルトはリストビュー
    this.onBackButtonPressed,
    this.showEditButton = false, // デフォルトは表示しない
    this.onEditButtonPressed,
    this.showSettingsButton = false, // デフォルトは表示しない
    this.onSettingsButtonPressed,
    this.showSearchBackButton = false, // デフォルトは表示しない
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: showTitle
          ? Text(
              title,
              style: TextStyle(color: AppColors.onPrimary),
            )
          : null, // タイトルの表示制御
      backgroundColor: isMapView
          ? Colors.transparent
          : AppColors.primary, // マップ表示の場合は背景を透明にする
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.onPrimary),
              onPressed: onBackButtonPressed ??
                  () {
                    Navigator.of(context).pop();
                  },
            )
          : Container(), // デフォルトの戻るボタンを常に非表示にする
      actions: [
        if (showEditButton)
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.onPrimary),
            onPressed: onEditButtonPressed,
          ),
        if (showSettingsButton)
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.onPrimary),
            onPressed: onSettingsButtonPressed,
          ),
      ], // 編集ボタンと設定ボタンの表示制御
      centerTitle: true, // タイトルをセンターに固定
      bottom: showSearchBox
          ? PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: CustomSearchBox(
                showToggleButton: showToggleButton,
                onToggleButtonPressed: onToggleButtonPressed,
                isMapView: isMapView,
                onBackButtonPressed: onBackButtonPressed,
                showSearchBackButton: showSearchBackButton,
              ), // 検索ボックスの表示
            )
          : null, // 検索ボックスの表示制御
      elevation: 0, // 影を無くす
    );
  }

  @override
  Size get preferredSize =>
      showSearchBox ? Size.fromHeight(88.0) : Size.fromHeight(56.0);
}
