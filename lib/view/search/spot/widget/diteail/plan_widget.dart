import 'package:flutter/material.dart';
import 'package:mapapp/view/search/spot/widget/diteail/plan.dart';

class SpotDiteailPlanWidget extends StatelessWidget {
  final List<Map<String, String>> spots;
  final Function(String) onSpotTap;

  SpotDiteailPlanWidget({required this.spots, required this.onSpotTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // スクロールを無効にする
      itemCount: spots.length,
      itemBuilder: (context, index) {
        final spot = spots[index];
        return Column(
          children: [
            SpotDiteailPlan(
              name: spot['name']!,
              category: spot['station']!,
              image: spot['image']!,
              onTap: () => onSpotTap(spot['name']!),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
