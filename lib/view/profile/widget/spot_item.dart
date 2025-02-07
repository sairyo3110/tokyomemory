import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/businesslogic/favorite/favorite_spot.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/view/search/spot/spot_detail.dart';

class ProfileSpotItem extends StatefulWidget {
  final Alignment heartIconAlignment;
  final int spotId;

  ProfileSpotItem({
    this.heartIconAlignment = Alignment.topRight,
    required this.spotId,
  }); // デフォルトは右上

  @override
  _ProfileSpotItemState createState() => _ProfileSpotItemState();
}

class _ProfileSpotItemState extends State<ProfileSpotItem> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // 画面の横幅を取得
    final screenWidth = MediaQuery.of(context).size.width;
    final FavoriteService favoriteService = FavoriteService();

    return GestureDetector(
      onTap: () async {
        setState(() {
          _isLoading = true;
        });

        print('spotId: ${widget.spotId}');
        // スポットの詳細情報を取得
        Spot? spotDetail =
            await favoriteService.fetchSpotDetails(widget.spotId);

        setState(() {
          _isLoading = false;
        });

        if (spotDetail != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpotDetail(spot: spotDetail),
            ),
          );
        } else {
          // 詳細情報が取得できなかった場合の処理
          print('Error: Spot details not found for spotId: ${widget.spotId}');
        }
      },
      child: Stack(
        children: [
          Container(
            width: screenWidth / 3, // 横幅を3分割
            height: screenWidth / 3, // 横幅に合わせて正方形にする場合
            child: CachedNetworkImage(
              imageUrl:
                  'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${widget.spotId}/1.png',
              fit: BoxFit.cover, // 画像を引き伸ばして全体をカバー
              errorWidget: (context, url, dynamic error) => Image.asset(
                'images/noimage.png', // 代替画像のパス
                fit: BoxFit.cover,
                width: screenWidth / 3, // 横幅を3分割
                height: screenWidth / 3, // 横幅に合わせて正方形にする場合
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
