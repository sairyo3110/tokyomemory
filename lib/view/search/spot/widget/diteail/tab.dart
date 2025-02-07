import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';

class SpotDitealTextTab extends StatelessWidget {
  final String text;

  SpotDitealTextTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 25,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
