import 'package:flutter/material.dart';
import 'package:mapapp/view/search/spot/spot_detail.dart';
import 'package:mapapp/view/search/spot/spot_main.dart';
import 'package:provider/provider.dart';
import 'package:mapapp/businesslogic/spot/spot_main.dart';
import 'package:mapapp/view/search/searchbox/widget/area_widget.dart';
import 'package:mapapp/view/search/searchbox/widget/line.dart';
import 'package:mapapp/view/search/searchbox/widget/search_spot_widget.dart';
import 'package:mapapp/view/search/searchbox/widget/title.dart';

class SpotSearchBoxUnderscreen extends StatelessWidget {
  final VoidCallback onClose;

  SpotSearchBoxUnderscreen({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpotViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                SizedBox(height: 30),
                if (viewModel.filteredAreas.isNotEmpty) ...[
                  SearchBoxTitleText(text: "エリア"),
                  SearchAreawidget(
                    locations: viewModel.filteredAreas,
                    onLocationTap: (location) {
                      viewModel.filterSpots(location); // エリアでフィルタリング
                      onClose(); // フィルタリング後に画面を閉じる
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpotScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  SearchLine(),
                ],
                if (viewModel.filteredStations.isNotEmpty) ...[
                  SizedBox(height: 30),
                  SearchBoxTitleText(text: "駅"),
                  SearchAreawidget(
                    locations: viewModel.filteredStations,
                    onLocationTap: (location) {
                      viewModel.filterSpots(location); // 駅名でフィルタリング
                      onClose(); // フィルタリング後に画面を閉じる
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpotScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  SearchLine(),
                ],
                if (viewModel.filteredSpots.isNotEmpty) ...[
                  SizedBox(height: 30),
                  SearchBoxTitleText(text: "スポット"),
                  SearchSpotWidget(
                    spots: viewModel.filteredSpots, // フィルタリングされたスポットリストを渡す
                    onSpotTap: (index) {
                      onClose(); // フィルタリング後に画面を閉じる
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SpotDetail(spot: viewModel.filteredSpots[index]),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
