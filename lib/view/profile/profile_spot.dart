import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/favorite/favorite_spot.dart';
import 'package:mapapp/view/profile/widget/spot_item.dart';

class ProfileSpotList extends StatefulWidget {
  @override
  _ProfileSpotListState createState() => _ProfileSpotListState();
}

class _ProfileSpotListState extends State<ProfileSpotList> {
  late Future<List<int>> _favoriteSpots;

  @override
  void initState() {
    super.initState();
    _loadFavoriteSpots();
  }

  Future<void> _loadFavoriteSpots() async {
    setState(() {
      _favoriteSpots = FavoriteService().fetchUserFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadFavoriteSpots,
      child: FutureBuilder<List<int>>(
        future: _favoriteSpots,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('お気に入りスポットがありません'));
          } else {
            List<int> favoriteSpots = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3列
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                childAspectRatio: 1.0, // 正方形
              ),
              itemCount: favoriteSpots.length,
              itemBuilder: (context, index) {
                return ProfileSpotItem(
                  spotId: favoriteSpots[index],
                );
              },
            );
          }
        },
      ),
    );
  }
}
