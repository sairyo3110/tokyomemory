import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // インスタンス化を防ぐためのプライベートコンストラクタ

  // メインカラー
  static const Color primary = Color(0xFF444440);
  static const Color primaryVariant = Color(0xFF3700B3);

  // アクセントカラー
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);

  // 背景カラー
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  // エラーカラー
  static const Color error = Color(0xFFB00020);

  // テキストカラー
  static const Color onPrimary = Color(0xFFFBE9DE);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);
}
