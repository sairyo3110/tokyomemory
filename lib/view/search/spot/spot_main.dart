import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/spot/spot_main.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/search/spot/spot_list.dart';
import 'package:mapapp/view/search/spot/spot_map.dart';
import 'package:provider/provider.dart';

class SpotScreen extends StatefulWidget {
  final bool initialMapView;

  SpotScreen({this.initialMapView = false});

  @override
  _SpotScreenState createState() => _SpotScreenState();
}

class _SpotScreenState extends State<SpotScreen> {
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _showMap = widget.initialMapView;
  }

  void _toggleView() {
    setState(() {
      _showMap = !_showMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Search',
        showTitle: false,
        showToggleButton: true,
        onToggleButtonPressed: _toggleView,

        isMapView: _showMap,

        showSearchBox: true, // 検索ボックスを表示
        showSearchBackButton: true, // 検索ボックスの戻るボタンを表示
      ),
      body: BaseScreen(
        body: Stack(
          children: [
            Positioned.fill(
              child: Consumer<SpotViewModel>(
                builder: (context, spotViewModel, child) {
                  return spotViewModel.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _showMap
                          ? SearchSpotMap(spots: spotViewModel.filteredSpots)
                          : SpotList(spots: spotViewModel.filteredSpots);
                },
              ),
            ),
            //TODO 次回のアップデートでフィルタリング機能を実装
            //Positioned(
            //  top: 0,
            //  left: 0,
            //  right: 0,
            //  child: SpottabWidget(
            //    isMapView: _showMap,
            //  ),
            //),
          ],
        ),
      ),
    );
  }
}
