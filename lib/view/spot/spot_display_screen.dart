import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/component/bottan/favorite_bottan.dart';
import 'package:mapapp/component/serachbox/map_search_box.dart';
import 'package:mapapp/importer.dart';
import 'package:mapapp/provider/PlaceChategories.dart';
import 'package:mapapp/provider/places_provider.dart';
import 'package:mapapp/model/rerated_model.dart';
import 'package:mapapp/view/spot/spot_detail_screen.dart';
import 'package:mapapp/repository/map_controller_provider.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SpotDisplayScreen extends StatefulWidget {
  final bool showMap;
  final String location; // 選択された場所
  final String price; // 選択された価格範囲
  final String category; // 選択されたカテゴリーID
  final List<int>? filteredPlaceIds; // フィルタリングされた場所のIDのリスト

  const SpotDisplayScreen({
    super.key,
    this.showMap = false,
    required this.category,
    required this.location,
    required this.price,
    this.filteredPlaceIds, // 新たに追加された引数
  });

  @override
  // ignore: library_private_types_in_public_api
  _SpotDisplayScreenState createState() => _SpotDisplayScreenState();
}

class _SpotDisplayScreenState extends State<SpotDisplayScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<PlaceDetail> spots = [];
  final List<PlaceDetail> filteredSpots = [];
  Map<String, PlaceDetail> markerData = {};
  final Completer<MapboxMapController> _controller = Completer();
  bool _showMap = false;
  PageController pageController = PageController();
  bool _isDataLoaded = false;
  final String endpoint = 'places';
  String? userid;

  final String _style = 'mapbox://styles/enplace/cllwj4gw4007q01rf90r18bdh';
  final double _initialZoom = 12.5;
  Position? _yourLocation;

  MapboxMapController? controller;

  PlaceDetail? _selectedPlace; // 選択されたPlaceを保存するための変数を追加

  List<PlaceCategorySub> categorySubs = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SpotDisplayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _loadUserid();
    _showMap = widget.showMap;
    _fetchCategoriesSub(); // カテゴリーサブリストを取得する

    _getLocation().then((position) {
      setState(() {
        _yourLocation = position;

        // filteredPlaceIdsが提供されている場合、それに基づいてデータを取得
        if (widget.filteredPlaceIds != null &&
            widget.filteredPlaceIds!.isNotEmpty) {
          _fetchFilteredPlaces(widget.filteredPlaceIds!);
        } else {
          // filteredPlaceIdsが提供されていない場合、全ての場所のデータを取得
          _fetchAllPlaces();
        }
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });
  }

  void _fetchCategoriesSub() async {
    try {
      categorySubs = await Provider.of<PlacesProvider>(context, listen: false)
          .fetchPlaceCategoriesSub();
    } catch (e) {
      print("Error fetching category subs: $e");
    }
  }

  void _fetchAllPlaces() {
    Provider.of<PlacesProvider>(context, listen: false)
        .fetchPlaceAllDetails(endpoint)
        .then((data) {
      // クーポンがある場所とない場所のリストを作成
      List<PlaceDetail> spotsWithCoupons = [];
      List<PlaceDetail> spotsWithoutCoupons = [];

      for (var spot in data) {
        if (spot.cCouponId != null && spot.cCouponId! > 0) {
          spotsWithCoupons.add(spot);
        } else {
          spotsWithoutCoupons.add(spot);
        }
      }

      // クーポンがある場所を距離でソート
      spotsWithCoupons.sort(
          (a, b) => _calculateDistance(a).compareTo(_calculateDistance(b)));

      // クーポンがない場所を距離でソート
      spotsWithoutCoupons.sort(
          (a, b) => _calculateDistance(a).compareTo(_calculateDistance(b)));

      // 両リストを結合して全体のリストを更新
      setState(() {
        spots
          ..clear()
          ..addAll(spotsWithCoupons)
          ..addAll(spotsWithoutCoupons);
        _isDataLoaded = true;
        _filterSpots();
      });
    }).catchError((error) {
      print('Error fetching places: $error');
    });
  }

  void _fetchFilteredPlaces(List<int> placeIds) {
    Provider.of<PlacesProvider>(context, listen: false)
        .fetchFilteredPlaceDetails(placeIds)
        .then((data) {
      // クーポンがある場所とない場所のリストを作成
      List<PlaceDetail> spotsWithCoupons = [];
      List<PlaceDetail> spotsWithoutCoupons = [];

      for (var spot in data) {
        if (spot.cCouponId != null && spot.cCouponId! > 0) {
          spotsWithCoupons.add(spot);
        } else {
          spotsWithoutCoupons.add(spot);
        }
      }

      // クーポンがある場所を距離でソート
      spotsWithCoupons.sort(
          (a, b) => _calculateDistance(a).compareTo(_calculateDistance(b)));

      // クーポンがない場所を距離でソート
      spotsWithoutCoupons.sort(
          (a, b) => _calculateDistance(a).compareTo(_calculateDistance(b)));
      setState(() {
        spots
          ..clear()
          ..addAll(spotsWithCoupons)
          ..addAll(spotsWithoutCoupons);

        _isDataLoaded = true;
        _filterSpots();
      });
    }).catchError((error) {
      print('Error fetching filtered places: $error');
    });
  }

  double _calculateDistance(PlaceDetail place) {
    if (_yourLocation == null || place.address!.isEmpty) {
      return double.maxFinite;
    }

    double lat1 = _yourLocation!.latitude;
    double lon1 = _yourLocation!.longitude;
    double? lat2 = place.paLatitude;
    double? lon2 = place.paLongitude; // ここを修正

    double distance = Geolocator.distanceBetween(lat1, lon1, lat2!, lon2!);
    return distance;
  }

  void _filterSpots() {
    if (_showMap) controller?.clearSymbols();
    filteredSpots.clear(); // フィルタリング前にリストをクリアする

    spots.removeWhere((spot) {
      bool categoryMatch = true;
      bool locationMatch = true;
      bool priceMatch = true;
      // 選択されたPlaceに基づくフィルタリング
      if (_selectedPlace != null) {
        // ignore: iterable_contains_unrelated_type
        locationMatch =
            spot.address!.contains(_selectedPlace!.address as Pattern);
      }
      if (categoryMatch && locationMatch && priceMatch) {
        filteredSpots.add(spot);
      }
      print("Filtered spots count: ${filteredSpots.length}");
      return !(categoryMatch && locationMatch && priceMatch);
    });
  }

  Future<void> _loadUserid() async {
    try {
      AuthUser authUser = await Amplify.Auth.getCurrentUser();
      setState(() {
        userid = authUser.userId;
        print('User ID: $userid');
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // widget.categoryを整数型に変換
    MapControllerProvider mapControllerProvider =
        Provider.of<MapControllerProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          if (!_isDataLoaded)
            const Center(
                child: CircularProgressIndicator()), // データがロード中の場合、インジケータを表示
          if (_isDataLoaded)
            _showMap
                ? MapboxMap(
                    styleString: _style,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          _yourLocation?.latitude ?? 35.6895, // デフォルトの緯度を設定
                          _yourLocation?.longitude ?? 139.6917 // デフォルトの経度を設定
                          ),
                      zoom: _initialZoom,
                    ),
                    myLocationEnabled: true,
                    onMapCreated: (MapboxMapController controller) {
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                      }
                      _controller.future.then((mapboxMap) {
                        mapboxMap.onSymbolTapped
                            .add(_onSymbolTap); // シンボル（マーカー）がタップされたときのリスナーを追加
                      });
                      addImageAndMarkers(spots);
                      this.controller = controller;
                      mapControllerProvider.setMapController(controller);
                      if (_selectedPlace != null) {
                        controller.animateCamera(CameraUpdate.newLatLngZoom(
                            LatLng(_selectedPlace!.paLatitude as double,
                                _selectedPlace!.paLongitude as double),
                            16.0));
                      }
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 140.0),
                    itemCount: filteredSpots.length, // filteredSpotsを使用
                    itemBuilder: (_, int index) {
                      final spot = filteredSpots[index]; // filteredSpotsを使用
                      bool shouldDisplayRow =
                          double.tryParse(spot.dayMin ?? '0')?.toInt() != 0 ||
                              double.tryParse(spot.dayMax ?? '0')?.toInt() !=
                                  0 ||
                              double.tryParse(spot.nightMin ?? '0')?.toInt() !=
                                  0 ||
                              double.tryParse(spot.nightMax ?? '0')?.toInt() !=
                                  0;
                      String categoryName = categorySubs
                          .firstWhere(
                              (categorySub) =>
                                  categorySub.categoryId == spot.subcategoryId,
                              orElse: () => PlaceCategorySub(
                                  categoryId: 0, name: '', parentCategoryId: 0))
                          .name;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpotDetailScreen(
                                  parentContext: context, spot: spot),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.all(10.0), // カードの周りにマージンを追加
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0), // 角丸の設定
                          ),
                          elevation: 3.0, // 影を付ける
                          child: Padding(
                            padding: EdgeInsets.only(left: 10), // 左側にのみパディングを適用
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 140.0, // 画像の幅
                                  height: 140.0, // 画像の高さ
                                  child: (spot.imageUrl?.isEmpty ?? true)
                                      ? Image(
                                          image:
                                              AssetImage('images/noimage.png'),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.imageUrl}/1.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0), // テキストセクションのパディング
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  spot.name ?? '',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow: TextOverflow
                                                      .ellipsis, // タイトルが長い場合は省略記号を表示
                                                ),
                                              ),
                                              if (!kIsWeb)
                                                FavoriteIconWidget(
                                                  userId: userid,
                                                  placeId: spot.placeId ??
                                                      0, // 実際の場所IDを設定する
                                                  isFavorite:
                                                      false, // お気に入り状態を設定する
                                                ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF6E6DC),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  child: Text(
                                                    categoryName,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                if ((spot.cCouponId ?? 0) != 0)
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0,
                                                            vertical: 4.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child: Text(
                                                      'クーポン',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                              ]),
                                              SizedBox(height: 10),
                                              Text(
                                                '${spot.city}/${spot.nearestStation}',
                                                style: TextStyle(fontSize: 10),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Icon(
                                                      size: 15.0,
                                                      Icons
                                                          .directions_walk), // Add your desired icon
                                                  Text(
                                                    ('${spot.nearestStation}より ${spot.walkingMinutes}分'),
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              if (shouldDisplayRow)
                                                Row(
                                                  children: [
                                                    Icon(
                                                        size: 15.0,
                                                        Icons
                                                            .currency_yen), // Add your desired icon
                                                    Text(
                                                      (double.tryParse(spot.dayMin ??
                                                                          '0')
                                                                      ?.toInt() ==
                                                                  0 &&
                                                              double.tryParse(
                                                                          spot.dayMax ??
                                                                              '0')
                                                                      ?.toInt() ==
                                                                  0)
                                                          ? '${double.tryParse(spot.nightMin ?? '0')?.toInt()}円 - ${double.tryParse(spot.nightMax ?? '0')?.toInt()}円'
                                                          : '${double.tryParse(spot.dayMin ?? '0')?.toInt()}円 - ${double.tryParse(spot.dayMax ?? '0')?.toInt()}円',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              SizedBox(height: 30),
                                            ],
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          if (_showMap)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: MediaQuery.of(context).size.height * 0.28,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  controller?.animateCamera(CameraUpdate.newLatLng(LatLng(
                      spots[value].paLatitude ?? 0.0,
                      spots[value].paLongitude ?? 0.0)));
                },
                itemCount: spots.length,
                itemBuilder: (_, index) {
                  final spot = spots[index];
                  bool shouldDisplayRow =
                      double.tryParse(spot.dayMin ?? '0')?.toInt() != 0 ||
                          double.tryParse(spot.dayMax ?? '0')?.toInt() != 0 ||
                          double.tryParse(spot.nightMin ?? '0')?.toInt() != 0 ||
                          double.tryParse(spot.nightMax ?? '0')?.toInt() != 0;
                  return Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpotDetailScreen(
                                  parentContext: context, spot: spot),
                            ),
                          );
                        },
                        child: Padding(
                            padding: EdgeInsets.only(left: 30), // 左側にのみパディングを適用
                            child: Row(children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.3, // 画像の幅を画面幅の30%に設定
                                height: MediaQuery.of(context).size.height *
                                    0.14, // 画像の高さを画面高の20%に設定
                                child: (spot.imageUrl?.isEmpty ?? true)
                                    ? Image(
                                        image: AssetImage('images/noimage.png'),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.imageUrl}/1.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0), // テキストセクションのパディング
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                spot.name ?? '',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow
                                                    .ellipsis, // タイトルが長い場合は省略記号を表示
                                              ),
                                            ),
                                            FavoriteIconWidget(
                                              userId: userid,
                                              placeId: spot.placeId ??
                                                  0, // 実際の場所IDを設定する
                                              isFavorite: false, // お気に入り状態を設定する
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 4.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF6E6DC),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: Text(
                                                  (spot.pcsName ?? '更新中'),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              if ((spot.cCouponId ?? 0) != 0)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  child: Text(
                                                    'クーポン',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                            ]),
                                            SizedBox(height: 10),
                                            Text(
                                              (spot.city ?? '') +
                                                  '/' +
                                                  (spot.nearestStation ?? ''),
                                              style: TextStyle(fontSize: 10),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Icon(
                                                    size: 15.0,
                                                    Icons
                                                        .directions_walk), // Add your desired icon
                                                Text(
                                                  ('${spot.nearestStation}より ${spot.walkingMinutes}分'),
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            if (shouldDisplayRow)
                                              Row(
                                                children: [
                                                  Icon(
                                                      size: 15.0,
                                                      Icons
                                                          .currency_yen), // Add your desired icon
                                                  Text(
                                                    (double.tryParse(spot.dayMin ??
                                                                        '0')
                                                                    ?.toInt() ==
                                                                0 &&
                                                            double.tryParse(
                                                                        spot.dayMax ??
                                                                            '0')
                                                                    ?.toInt() ==
                                                                0)
                                                        ? '${double.tryParse(spot.nightMin ?? '0')?.toInt()}円 - ${double.tryParse(spot.nightMax ?? '0')?.toInt()}円'
                                                        : '${double.tryParse(spot.dayMin ?? '0')?.toInt()}円 - ${double.tryParse(spot.dayMax ?? '0')?.toInt()}円',
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ]),
                                ),
                              )
                            ])),
                      ),
                    ),
                  );
                },
              ),
            ),
          Positioned(
            left: 10.0,
            right: 10.0,
            child: Container(
              color: _showMap
                  ? Colors.transparent
                  : Color(0xFF444440), // _showMapがtrueの場合は透明な背景
              child: Column(children: [
                SizedBox(height: 60), // 上部に余白を追加
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: MapSearchBox(
                        controller: _searchController,
                        onPlaceSelected: (selectedPlace) {
                          setState(() {
                            _selectedPlace = selectedPlace as PlaceDetail?;
                            _filterSpots();
                            addImageAndMarkers(spots);
                            if (selectedPlace != null && controller != null) {
                              Future.delayed(Duration(milliseconds: 500), () {
                                controller!.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                        LatLng(
                                            _selectedPlace!.paLatitude
                                                as double,
                                            _selectedPlace!.paLongitude
                                                as double),
                                        16.0));
                              });
                            } else {
                              _reloadScreen(context);
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    if (!kIsWeb)
                      FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          setState(() {
                            _showMap = !_showMap;
                          });
                          if (_showMap && controller != null) {
                            // _showMapがtrueに変更された場合にのみマーカーを再設定
                            addImageAndMarkers(spots);

                            if (_selectedPlace != null) {
                              Future.delayed(Duration(milliseconds: 500), () {
                                controller!.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                        LatLng(
                                            _selectedPlace!.paLatitude
                                                as double,
                                            _selectedPlace!.paLongitude
                                                as double),
                                        16.0));
                              });
                            }
                          }
                        },
                        child: Icon(
                          _showMap ? Icons.list : Icons.map,
                          color: Colors.black, // アイコンの色を赤に設定
                        ),
                        backgroundColor: Color(0xFFF6E6DC), // 背景色を緑に設定
                        tooltip: 'Toggle View',
                      ),
                  ],
                ),
              ]),
            ),
          ),
          Positioned(
            top: 125.0, // MapSearchBoxの下に配置
            left: 20.0,
            right: 10.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // 左寄せにする
              children: [
                IntrinsicWidth(
                  child: Text(
                    '現在地から近い順',
                    style: TextStyle(fontSize: 10, color: Color(0xFFF6E6DC)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Position> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      print(
          "Current location: Lat: ${position.latitude}, Lng: ${position.longitude}");
      return position;
    } catch (error) {
      print("Error getting location: $error");
      throw error; // または、適切なエラーハンドリングを実施
    }
  }

  Future<void> addImageAndMarkers(List<PlaceDetail> spots) async {
    final defaultIconId = 'default-marker-icon';

    // デフォルト画像を読み込む
    final ByteData bytes = await rootBundle.load('images/another_image.jpg');
    final Uint8List defaultList = bytes.buffer.asUint8List();
    await controller?.addImage(defaultIconId, defaultList);

    final client = http.Client();

    try {
      for (int i = 0; i < spots.length; i++) {
        final spot = spots[i];
        var iconId = defaultIconId; // デフォルトのアイコンIDを使用

        if (spot.categories != null && spot.categories!.isNotEmpty) {
          final categoryName = spot.categories![0].name;
          final imageUrl =
              'https://mymapapp.s3.ap-northeast-1.amazonaws.com/mappin/${Uri.encodeComponent(categoryName!)}/1.png';

          try {
            final response = await client.get(Uri.parse(imageUrl));

            if (response.statusCode == 200) {
              final Uint8List list = response.bodyBytes;
              iconId = 'marker-icon-$categoryName';
              await controller?.addImage(iconId, list);
            }
          } catch (e) {
            // エラーが発生した場合はデフォルトアイコンIDを使用
            print('Error downloading image: $e');
          }
        }

        // マーカーを追加
        addMarker(spot, iconId);
      }
    } finally {
      client.close();
    }
  }

  void addMarker(PlaceDetail spot, String iconId) {
    if (controller != null && spot.address!.isNotEmpty) {
      controller!
          .addSymbol(SymbolOptions(
        geometry: LatLng(spot.paLatitude ?? 0.0, spot.paLongitude ?? 0.0),
        iconImage: iconId,
        iconSize: 3.0,
      ))
          .then((symbol) {
        markerData[symbol.id] = spot;
      });
    }
  }

  RangeValues? extractPriceRange(String price) {
    // ¥記号やカンマを除去して数字のみを取得
    var matches = RegExp(r'(\d+)').allMatches(price);
    var extractedNumbers = matches.map((m) => int.parse(m.group(1)!)).toList();

    if (extractedNumbers.length == 0) {
      return null;
    } else if (extractedNumbers.length == 1) {
      return RangeValues(
          extractedNumbers[0].toDouble(), extractedNumbers[0].toDouble());
    } else {
      return RangeValues(
          extractedNumbers[0].toDouble(), extractedNumbers[1].toDouble());
    }
  }

  // マークをタップしたときに Symbol の情報を表示する
  // マークをタップしたときの処理
  void _onSymbolTap(Symbol symbol) {
    final spot = markerData[symbol.id]; // シンボルIDをキーとして、スポットデータを取得
    if (spot != null) {
      _scrollToCard(
          spot.paLatitude ?? 0.0, spot.paLongitude ?? 0.0); // 緯度と経度を渡す
    }
  }

  void _scrollToCard(double latitude, double longitude) {
    // スポットリストから該当の緯度と経度を持つスポットのインデックスを検索
    final index = spots.indexWhere(
        (spot) => spot.paLatitude == latitude && spot.paLongitude == longitude);
    if (index != -1) {
      // インデックスが見つかった場合、対応するカードにスクロール
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _reloadScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => SpotDisplayScreen(
        category: widget.category,
        location: widget.location,
        price: widget.price,
        showMap: widget.showMap,
      ),
    ));
  }
}
