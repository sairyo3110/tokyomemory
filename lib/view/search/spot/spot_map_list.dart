import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/view/search/spot/widget/spot_item_map.dart';

class SpotMapList extends StatefulWidget {
  final List<Spot> spots;
  final Spot? selectedSpot;
  final Function(Spot) onSpotScrolled;
  final String userId; // ユーザーIDを追加

  SpotMapList({
    Key? key,
    required this.spots,
    this.selectedSpot,
    required this.onSpotScrolled,
    required this.userId, // ユーザーIDをコンストラクタに追加
  }) : super(key: key);

  @override
  _SpotMapListState createState() => _SpotMapListState();
}

class _SpotMapListState extends State<SpotMapList> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedSpot();
    });
  }

  @override
  void didUpdateWidget(covariant SpotMapList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSpot != widget.selectedSpot) {
      _scrollToSelectedSpot();
    }
  }

  void _scrollToSelectedSpot() {
    if (widget.selectedSpot != null) {
      final index = widget.spots.indexOf(widget.selectedSpot!);
      if (index != -1) {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.spots.length,
        onPageChanged: (index) {
          widget.onSpotScrolled(widget.spots[index]); // スクロール時にコールバックを呼び出す
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: SpotMapItem(
              spot: widget.spots[index],
              userId: widget.userId, // ユーザーIDを渡す
            ),
          );
        },
      ),
    );
  }
}
