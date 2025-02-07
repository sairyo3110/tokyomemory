import 'package:flutter/material.dart';
import 'package:mapapp/colors.dart';
import 'package:mapapp/utils.dart';

class SpotDitealShareWidget extends StatelessWidget {
  final String favoriteType;
  final int favoriteId;
  final String name;

  SpotDitealShareWidget({
    required this.favoriteType,
    required this.favoriteId,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (favoriteType == 'spot') {
          shareContent(
            context: context,
            placeId: favoriteId.toString(),
            name: name,
          );
        } else {
          sharePlan(
            context: context,
            planId: favoriteId.toString(),
            name: name,
          );
        }
      },
      child: Row(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Row(
                children: [
                  SizedBox(width: 50),
                  Icon(
                    Icons.reply,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '共有',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
