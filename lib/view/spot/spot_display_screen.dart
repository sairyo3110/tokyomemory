import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/component/map_search_box.dart';
import 'package:mapapp/test/places_provider.dart';
import 'package:mapapp/test/rerated_model.dart';
import 'package:mapapp/view/spot/spot_detail_screen.dart';
import 'package:mapapp/view_model/map_controller_provider.dart';
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

  const SpotDisplayScreen({
    super.key,
    this.showMap = false,
    required this.category,
    required this.location,
    required this.price,
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

  final String _style = 'mapbox://styles/enplace/cllwj4gw4007q01rf90r18bdh';
  final double _initialZoom = 12.5;
  Position? _yourLocation;

  MapboxMapController? controller;

  PlaceDetail? _selectedPlace; // 選択されたPlaceを保存するための変数を追加

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

    _showMap = widget.showMap;

    _getLocation().then((position) {
      setState(() {
        _yourLocation = position;
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
      });
    }).catchError((error) {
      print('Error getting location: $error');
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

      // カテゴリIDに基づくフィルタリング
      if (widget.category.isNotEmpty) {
        try {
          int filterCategoryId = int.parse(widget.category);
          categoryMatch = spot.subcategoryId == filterCategoryId;
          // ignore: empty_catches
        } catch (e) {}
      }

      // 位置に基づくフィルタリング
      if (widget.location.isNotEmpty) {
        locationMatch = spot.address!.contains(widget.location);
      }

      // 価格に基づくフィルタリング
      if (widget.price.isNotEmpty) {
        try {
          RangeValues? priceRange = extractPriceRange(widget.price);
          if (priceRange != null && spot.price!.isNotEmpty) {
            int spotPrice = int.parse(spot.price!
                .replaceAll(RegExp(r'[^0-9]'), '')); // 価格文字列から数字だけを取り出す
            priceMatch =
                spotPrice >= priceRange.start && spotPrice <= priceRange.end;
          }
          // ignore: empty_catches
        } catch (e) {}
      }
      // 選択されたPlaceに基づくフィルタリング
      if (_selectedPlace != null) {
        // ignore: iterable_contains_unrelated_type
        locationMatch =
            spot.address!.contains(_selectedPlace!.address as Pattern);
      }
      if (categoryMatch && locationMatch && priceMatch) {
        filteredSpots.add(spot);
      }
      return !(categoryMatch && locationMatch && priceMatch);
    });
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
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpotDetailScreen(spot: spot),
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
                            padding: EdgeInsets.all(10.0), // カード内のパディング
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 170.0, // 画像の幅
                                  height: 120.0, // 画像の高さ
                                  child: Image.network(
                                    'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.imageUrl}/1.png',
                                    fit: BoxFit.cover, // Image covers the box
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      // If the image fails to load, this builder will work to show the placeholder
                                      return Image.asset(
                                        'images/noimage.png',
                                        fit: BoxFit
                                            .cover, // Placeholder image covers the box
                                      );
                                    },
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
                                          Text(
                                            spot.name ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 7.0,
                                                    vertical: 3.0),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFF6E6DC),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: Text(
                                                  (spot.pcsName ?? ''),
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.black),
                                                ),
                                              ),
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
                                                            .attach_money), // Add your desired icon
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
                                              if ((spot.cCouponId ?? 0) != 0)
                                                Column(
                                                  children: [
                                                    SizedBox(height: 5),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0,
                                                              vertical: 4.0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                      child: Text(
                                                        'クーポン',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white),
                                                      ),
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
              height: MediaQuery.of(context).size.height * 0.26,
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
                              builder: (context) =>
                                  SpotDetailScreen(spot: spot),
                            ),
                          );
                        },
                        child: Padding(
                            padding: EdgeInsets.all(10.0), // カード内のパディング
                            child: Row(children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.4, // 画像の幅を画面幅の30%に設定
                                height: MediaQuery.of(context).size.height *
                                    0.14, // 画像の高さを画面高の20%に設定
                                child: Image.network(
                                  'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.imageUrl}/1.png',
                                  fit: BoxFit.cover, // Image covers the box
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    // If the image fails to load, this builder will work to show the placeholder
                                    return Image.asset(
                                      'images/noimage.png',
                                      fit: BoxFit
                                          .cover, // Placeholder image covers the box
                                    );
                                  },
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
                                        Text(
                                          spot.name ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 7.0,
                                                  vertical: 3.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF6E6DC),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: Text(
                                                (spot.pcsName ?? ''),
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
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
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            if ((spot.cCouponId ?? 0) != 0)
                                              Column(
                                                children: [
                                                  SizedBox(height: 5),
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
                                                ],
                                              ),
                                            SizedBox(height: 30),
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
                            _selectedPlace =
                                selectedPlace as PlaceDetail?; // 選択されたPlaceを保存
                            _filterSpots();
                            addImageAndMarkers(spots);

                            if (selectedPlace != null && controller != null) {
                              // 選択された場所にカメラを移動
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
                              // selectedPlaceがnullの場合、_reloadScreen関数を呼び出す
                              _reloadScreen(context);
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
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
                                          _selectedPlace!.paLatitude as double,
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
