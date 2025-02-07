import 'package:flutter/material.dart';

class SpotTextIconTab extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  SpotTextIconTab({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt,
                    size: 20,
                    color: Colors.black,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )));
  }
}
