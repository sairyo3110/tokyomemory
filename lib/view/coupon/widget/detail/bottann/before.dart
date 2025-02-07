import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';

class CouponDetailBeforeBotann extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // 角に丸みをつける
        color: AppColors.onPrimary,
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          '特典を使用',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
