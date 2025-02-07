import 'package:flutter/material.dart';
import 'package:mapapp/view/search/searchbox/underscreen_plan.dart';
import 'package:mapapp/view/search/searchbox/underscreen_spot.dart';
import 'package:mapapp/view/common/tabbar.dart';

class SearchResultsScreen extends StatefulWidget {
  final VoidCallback onClose;

  SearchResultsScreen({required this.onClose});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height, // 高さ制約を与える
      child: Column(
        children: [
          CustomTabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'スポット'),
              Tab(text: 'プラン'),
            ],
          ),
          Expanded(
            // 高さ制約を持つ親ウィジェット内に配置する
            child: TabBarView(
              controller: _tabController,
              children: [
                SpotSearchBoxUnderscreen(onClose: widget.onClose),
                PlanSearchBoxUnderscreen(onClose: widget.onClose),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
