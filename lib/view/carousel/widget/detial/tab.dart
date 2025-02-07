import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';

class CarouselTextTab extends StatelessWidget {
  final String text;

  CarouselTextTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ));
  }
}
