import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/view/common/advertisement_banner_image.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/common/map/map.dart';
import 'package:mapapp/view/search/spot/spot_map_list.dart';

class SearchSpotMap extends StatefulWidget {
  final List<Spot> spots;

  SearchSpotMap({Key? key, required this.spots}) : super(key: key);

  @override
  _SearchSpotMapState createState() => _SearchSpotMapState();
}

class _SearchSpotMapState extends State<SearchSpotMap> {
  Spot? selectedSpot; // 選択されたスポットを保持する

  void _onSpotSelected(Spot spot) {
    setState(() {
      selectedSpot = spot; // 選択されたスポットを設定
    });
  }

  void _onSpotScrolled(Spot spot) {
    setState(() {
      selectedSpot = spot; // スクロールされたスポットを設定
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    return Scaffold(
      body: BaseScreen(
        body: Stack(
          children: [
            MapScreen(
              onSpotSelected: _onSpotSelected,
              selectedSpot: selectedSpot, // selectedSpotを渡す
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0), //TODO フィルタリングボタンが入ったら60に変更
                child: SpotMapList(
                  spots: widget.spots,
                  selectedSpot: selectedSpot,
                  onSpotScrolled: _onSpotScrolled, // スクロール時のコールバックを渡す
                  userId: userId ?? '', // ユーザーIDを渡す
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, left: 20.0, right: 20.0),
                child: LoggableImage(
                  imagePath: 'images/ad_banner.png',
                  logEventName: 'search_spot',
                  logParameters: {'spot_id': 1},
                  link: 'https://sora-tokyo-dateplan.com/spemocinema/',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
