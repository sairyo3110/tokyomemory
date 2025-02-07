import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/view/common/basescreen.dart';
import 'package:mapapp/view/search/spot/widget/list/filtering_widget.dart';
import 'package:mapapp/view/search/spot/widget/spot_item.dart';
import 'package:provider/provider.dart';
import 'package:mapapp/businesslogic/user/user.dart';

class SpotList extends StatelessWidget {
  final List<Spot> spots;

  SpotList({Key? key, required this.spots}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseScreen(
        body: Column(
          children: [
            SizedBox(height: 10), //TODO フィルタリングが入ったら50に変更
            SpotListFilteringWidget(
              count: spots.length,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final User? user = FirebaseAuth.instance.currentUser;
                    final userId = user?.uid;
                    return ListView.builder(
                      itemCount: spots.length,
                      itemBuilder: (context, index) {
                        return SpotItem(
                          spot: spots[index],
                          userId: userId ?? '', // userIdがnullの場合は空文字を渡す
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
