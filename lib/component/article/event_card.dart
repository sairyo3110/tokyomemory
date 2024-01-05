import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final VoidCallback onTap;

  EventCard({
    required this.title,
    required this.imagePath,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(20.0),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFFF6E6DC),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
                      width: 325,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '詳しく見る',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
