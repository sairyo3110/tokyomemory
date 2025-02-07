import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';

class SpotDetailTextIconTab extends StatelessWidget {
  final String text;
  final IconData icon;

  SpotDetailTextIconTab({required this.text, required this.icon});

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
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 12,
                color: Colors.white,
              ),
              SizedBox(width: 8), // アイコンとテキストの間にスペースを追加
              Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
