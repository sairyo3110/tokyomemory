import 'package:flutter/material.dart';

class TabBarContainer extends StatelessWidget {
  final TabController tabController;
  final List<String> tabLabels;

  const TabBarContainer({
    Key? key,
    required this.tabController,
    required this.tabLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF444440),
      child: TabBar(
        controller: tabController,
        labelColor: Color(0xFFF6E6DC),
        indicatorColor: Color(0xFFF6E6DC),
        tabs: tabLabels.map((label) => Tab(text: label)).toList(),
      ),
    );
  }
}
