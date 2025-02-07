import 'package:flutter/material.dart';

class SearchArea extends StatelessWidget {
  final String location;
  final VoidCallback onTap;

  SearchArea({required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(width: 20),
          Icon(Icons.location_on, color: Colors.white, size: 30),
          SizedBox(width: 20),
          Text(
            location,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
