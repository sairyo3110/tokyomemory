import 'package:flutter/material.dart';
import 'package:mapapp/view/search/searchbox/widget/area.dart';

class SearchAreawidget extends StatelessWidget {
  final List<String> locations;
  final Function(String) onLocationTap;

  SearchAreawidget({required this.locations, required this.onLocationTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: locations.length,
      physics: NeverScrollableScrollPhysics(), // スクロールを無効にする
      itemBuilder: (context, index) {
        return Column(
          children: [
            SearchArea(
              location: locations[index],
              onTap: () => onLocationTap(locations[index]),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
