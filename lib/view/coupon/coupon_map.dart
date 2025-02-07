import 'package:flutter/material.dart';
import 'package:mapapp/view/common/basescreen.dart';

class CouponMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseScreen(
      body: Container(
        child: Column(
          children: [
            Text(
              'CouponMap',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Go to Coupon'),
            ),
          ],
        ),
      ),
    ));
  }
}
