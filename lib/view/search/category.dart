import 'package:flutter/material.dart';
import 'package:mapapp/view/common/appbar.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/search/spot/spot_main.dart';

class CategoryhScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Search',
        showTitle: false,
        showSearchBox: true, // 検索ボックスを表示
      ),
      body: BaseScreen(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('CategotyScreen'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpotScreen()),
                  );
                },
                child: Text('Go to SearchSpotView'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
