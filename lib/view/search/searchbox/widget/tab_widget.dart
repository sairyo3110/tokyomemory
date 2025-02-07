import 'package:flutter/material.dart';
import 'package:mapapp/view/search/searchbox/widget/tab.dart';

class SearchTextTabWidget extends StatelessWidget {
  final List<String> texts;
  final Function(String) onTabTap;

  SearchTextTabWidget({required this.texts, required this.onTabTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30, // 高さを設定
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 横方向にスクロール
        padding: EdgeInsets.only(left: 30), // 左側にパディングを追加
        itemCount: texts.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              SearchTextTab(
                text: texts[index],
                onTap: () => onTabTap(texts[index]), // タップイベントを処理
              ),
              SizedBox(width: 10), // 各タブの間にスペースを追加
            ],
          );
        },
      ),
    );
  }
}
