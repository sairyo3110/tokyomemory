import 'package:flutter/material.dart';

class CouponDetailAfterBotann extends StatelessWidget {
  final VoidCallback onCheckedOut;

  CouponDetailAfterBotann({required this.onCheckedOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Row(
        children: [
          Icon(
            Icons.face,
            color: Colors.white,
            size: 42,
          ),
          SizedBox(width: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              '店舗スタッフにこの画面を見せてください',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: onCheckedOut,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), // 角に丸みをつける
                color: Colors.white,
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  '使用済みにする',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
