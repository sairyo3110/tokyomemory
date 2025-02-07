import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';

class CouponDetailUsesWidget extends StatelessWidget {
  final int uses;

  CouponDetailUsesWidget({required this.uses});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.confirmation_number, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Text('使用回数',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'あと$uses回使用できます。',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
