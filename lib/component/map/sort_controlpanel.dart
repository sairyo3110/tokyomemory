import 'package:flutter/material.dart';

import 'package:mapapp/importer.dart';

class LocationSortLabel extends StatelessWidget {
  const LocationSortLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 130.0,
      left: 20.0,
      right: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Text(
              '現在地から近い順',
              style: TextStyle(fontSize: 10, color: Color(0xFFF6E6DC)),
            ),
          ),
        ],
      ),
    );
  }
}
