import 'package:flutter/material.dart';

class CouponDetailCheckoutBotann extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // 角に丸みをつける
        color: Colors.grey[300],
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          '使用済み',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
