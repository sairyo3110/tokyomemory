import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';

class PlanItem extends StatelessWidget {
  final String imageUrl;
  final String planTitle;
  final String planDescription;
  final VoidCallback onTap;

  PlanItem({
    required this.imageUrl,
    required this.planTitle,
    required this.planDescription,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.primary,
        child: Column(
          children: [
            Container(
              height: 185,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorWidget: (context, url, dynamic error) => Image.asset(
                      'images/noimage.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.2), // 半透明の黒いオーバーレイ
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 130,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        planTitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                planDescription,
                style: TextStyle(fontSize: 10, color: Colors.white),
                textAlign: TextAlign.center, // テキストを中央揃え
              ),
            ),
          ],
        ),
      ),
    );
  }
}
