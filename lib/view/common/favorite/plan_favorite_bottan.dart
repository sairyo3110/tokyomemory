import 'package:flutter/material.dart';
import 'package:mapapp/repository/favorite/favorite_plan.dart';
import 'package:mapapp/view/common/login_dialog.dart';

class PlanFavoriteIconWidget extends StatefulWidget {
  final String? userId;
  final int placeId;
  final String type; // 追加：お気に入りのタイプを指定

  PlanFavoriteIconWidget({
    Key? key,
    required this.userId,
    required this.placeId,
    required this.type, // 追加：お気に入りのタイプ
  }) : super(key: key);

  @override
  _PlanFavoriteIconWidgetState createState() => _PlanFavoriteIconWidgetState();
}

class _PlanFavoriteIconWidgetState extends State<PlanFavoriteIconWidget> {
  late Future<bool> _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = _checkIfFavorite();
  }

  Future<bool> _checkIfFavorite() async {
    List<int> favorites = await fetchFavoritesplan(widget.userId ?? '');
    return favorites.contains(widget.placeId);
  }

  Future<void> _toggleFavorite() async {
    if (await _isFavorite) {
      // お気に入りを削除する
      removeFavoriteplan(widget.userId ?? '', widget.placeId, widget.type)
          .then((response) {
        // typeを渡す
        if (response.statusCode == 200) {
          setState(() {
            _isFavorite = Future.value(false);
          });
        }
      });
    } else {
      // お気に入りを追加する
      addFavoriteplan(widget.userId ?? '', widget.placeId, widget.type)
          .then((response) {
        // typeを渡す
        if (response.statusCode == 200) {
          setState(() {
            _isFavorite = Future.value(true);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isFavorite,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Icon(
            Icons.favorite_border,
            color: Colors.white,
            size: 33.0,
          );
        } else if (snapshot.hasError) {
          return Text('エラー: ${snapshot.error}');
        } else {
          return IconButton(
            icon: Icon(
              (snapshot.data ?? false) ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 33,
            ), // お気に入りボタン
            onPressed: () {
              if (widget.userId == '') {
                // useridがnullの場合、ポップアップを表示
                showDialog(
                  context: context,
                  builder: (context) => LoginAlertDialog(),
                );
              } else {
                _toggleFavorite(); // お気に入りボタンが押されたときの処理
              }
            },
          );
        }
      },
    );
  }
}
