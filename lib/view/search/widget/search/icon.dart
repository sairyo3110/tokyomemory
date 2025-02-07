import 'package:flutter/material.dart';

class SearchIcon extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onTap;

  const SearchIcon({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}
