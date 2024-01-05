import 'package:flutter/material.dart';
import 'package:mapapp/repository/favorite_controller.dart';
import 'package:mapapp/view/navigation/main_bottom_navigation.dart';

class FavoriteIconWidget extends StatefulWidget {
  final String? userId;
  final int placeId;

  FavoriteIconWidget({
    Key? key,
    required this.userId,
    required this.placeId,
    required bool isFavorite,
  }) : super(key: key);

  @override
  _FavoriteIconWidgetState createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
  late Future<bool> _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = _checkIfFavorite();
  }

  Future<bool> _checkIfFavorite() async {
    List<int> favorites = await fetchFavorites(widget.userId ?? '');
    return favorites.contains(widget.placeId);
  }

  Future<void> _toggleFavorite() async {
    if (await _isFavorite) {
      // お気に入りを削除する
      removeFavorite(widget.userId ?? '', widget.placeId).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _isFavorite = Future.value(false); // Future<bool>型の値を代入
          });
        }
      });
    } else {
      // お気に入りを追加する
      addFavorite(widget.userId ?? '', widget.placeId).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _isFavorite = Future.value(true); // Future<bool>型の値を代入
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
          return CircularProgressIndicator(); // ローディングインジケーター
        } else if (snapshot.hasError) {
          return Text('エラー: ${snapshot.error}');
        } else {
          return IconButton(
            icon: Icon((snapshot.data ?? false)
                ? Icons.favorite
                : Icons.favorite_border), // お気に入りボタン
            onPressed: () {
              if (widget.userId == null) {
                // useridがnullの場合、ポップアップを表示
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('保存機能を使うには会員登録が必要です。'),
                    content: Text('マイページのログインボタンから会員登録を行ってください。'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('キャンセル'),
                        onPressed: () {
                          Navigator.of(context).pop(); // ダイアログを閉じる
                        },
                      ),
                      TextButton(
                        child: Text('ホームに戻る'),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => MainBottomNavigation()),
                          );
                        },
                      ),
                    ],
                  ),
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
