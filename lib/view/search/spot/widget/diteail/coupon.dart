import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';

class SpotDiteailCoupon extends StatelessWidget {
  final String text;
  final String images;
  final VoidCallback onTap;

  SpotDiteailCoupon(
      {required this.text, required this.images, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              SizedBox(width: 20),
              Icon(
                Icons.confirmation_number,
                color: AppColors.onPrimary,
                size: 20,
              ),
              SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'クーポンの表示',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
              Spacer(),
              Container(
                height: 90,
                width: 90,
                child: CachedNetworkImage(
                  imageUrl: images,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
