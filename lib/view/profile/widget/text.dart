import 'package:flutter/material.dart';

class ProfileTapTextWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ProfileTapTextWidget({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Text(text),
      ),
    );
  }
}
