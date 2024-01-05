import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Alignment alignment;
  final double fontSize;
  final String titleText;

  CustomAppBar({
    required this.height,
    required this.alignment,
    required this.fontSize,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF444440),
      title: Container(
        padding: EdgeInsets.all(8.0),
        alignment: alignment,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Text(
              titleText,
              style: TextStyle(
                color: Color(0xFFF6E6DC),
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
