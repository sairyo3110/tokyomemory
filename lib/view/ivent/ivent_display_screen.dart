import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mapapp/provider/places_provider.dart';
import 'package:mapapp/model/rerated_model.dart';
import 'package:mapapp/view/ivent/ivent_detail_screen.dart';
import 'package:mapapp/repository/map_controller_provider.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class IventDisplayScreen extends StatefulWidget {
  final bool showMap;
  final String location; // 選択された場所
  final String price; // 選択された価格範囲
  final String category; // 選択されたカテゴリーID
  const IventDisplayScreen({
    super.key,
    this.showMap = false,
    required this.category,
    required this.location,
    required this.price,
  });

  @override
  // ignore: library_private_types_in_public_api
  _IventDisplayScreenState createState() => _IventDisplayScreenState();
}

class _IventDisplayScreenState extends State<IventDisplayScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<PlaceDetail> spots = [];
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

  PlaceDetail? _selectedPlace;
  PlaceDetail? selectedSpot;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant IventDisplayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _showMap = widget.showMap;
    pageController = PageController();

    print('initState called');

    _getLocation().then((position) {
      print('Got location: $position');
      setState(() {
        _yourLocation = position;
        Provider.of<PlacesProvider>(context, listen: false)
            .fetchPlaceAllDetails(endpoint)
            .then((data) {
          print('Data fetched: ${data.length} items');

          List<PlaceDetail> filteredData =
              data.where((item) => item.subcategoryId == 17).toList();
          print('Filtered Data: ${filteredData.length} items');

          setState(() {
            spots.clear();
            spots.addAll(filteredData);
            _isDataLoaded = true;
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
                    itemCount: spots.length,
                    itemBuilder: (_, int index) {
                      final spot = spots[index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  IventDetailScreen(spot: spot),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 3.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 画像
                              SizedBox(
                                width: double.infinity, // 横いっぱい
                                height: 240.0, // 高さ
                                child: Image.network(
                                  'https://mymapapp.s3.ap-northeast-1.amazonaws.com/ivent/${spot.placeId}/1.png',
                                  fit: BoxFit.cover, // 画像をカバーするように調整
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('images/noimage.png',
                                        fit: BoxFit.cover);
                                  },
                                ),
                              ),
                              // テキスト情報
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      spot.name ?? '',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 7.0, vertical: 3.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF6E6DC),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        ('イベント'),
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '開催期間：${spot.address ?? ''}',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '${spot.city}/${spot.nearestStation}',
                                      style: TextStyle(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.directions_walk,
                                          size: 15.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            spot.nearestStation! +
                                                (spot.walkingMinutes != null
                                                    ? 'より ${spot.walkingMinutes}分'
                                                    : 'よりすぐ'),
                                            style: TextStyle(fontSize: 10),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.currency_yen,
                                          size: 15.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            () {
                                              double minPrice = [
                                                spot.dayMax,
                                                spot.dayMin,
                                                spot.nightMin,
                                                spot.nightMax,
                                              ]
                                                  .where((value) =>
                                                      value !=
                                                      null) // nullでない値のみを取得
                                                  .map((value) =>
                                                      double.tryParse(
                                                          value ?? '0') ??
                                                      0) // 数値に変換し、nullの場合は0を使用
                                                  .reduce(min); // 最小値を取得

                                              return minPrice == 0
                                                  ? '無料'
                                                  : '${minPrice.toInt()}円から〜';
                                            }(),
                                            style: TextStyle(fontSize: 10),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                                  IventDetailScreen(spot: spot),
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
                                  'https://mymapapp.s3.ap-northeast-1.amazonaws.com/ivent/${spot.placeId}/1.png',
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
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    ('${spot.nearestStation}より ${spot.walkingMinutes}分'),
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.currency_yen,
                                                  size: 15.0,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    () {
                                                      double minPrice = [
                                                        spot.dayMax,
                                                        spot.dayMin,
                                                        spot.nightMin,
                                                        spot.nightMax,
                                                      ]
                                                          .where((value) =>
                                                              value !=
                                                              null) // nullでない値のみを取得
                                                          .map((value) =>
                                                              double.tryParse(
                                                                  value ??
                                                                      '0') ??
                                                              0) // 数値に変換し、nullの場合は0を使用
                                                          .reduce(
                                                              min); // 最小値を取得

                                                      return minPrice == 0
                                                          ? '無料'
                                                          : '${minPrice.toInt()}円から〜';
                                                    }(),
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
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
                    if (!_showMap)
                      Text(
                        '12月のイベント情報',
                        style:
                            TextStyle(fontSize: 25, color: Color(0xFFF6E6DC)),
                      ),
                  ],
                ),
              ]),
            ),
          ),
          Positioned(
            top: 60,
            right: 10.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // 左寄せにする
              children: [
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
                          controller!.animateCamera(CameraUpdate.newLatLngZoom(
                              LatLng(_selectedPlace!.paLatitude as double,
                                  _selectedPlace!.paLongitude as double),
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
    if (controller != null && spot.prefecture!.isNotEmpty) {
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

  // マークをタップしたときの処理
  void _onSymbolTap(Symbol symbol) {
    final spot = markerData[symbol.id]; // シンボルIDをキーとして、スポットデータを取得
    if (spot != null) {
      _scrollToCard(
          spot.paLatitude ?? 0.0, spot.paLongitude ?? 0.0); // 緯度と経度を渡す
    }
  }

  void _scrollToCard(double latitude, double longitude) {
    print('Before index calculation'); // Debug statement
    final index = spots.indexWhere(
        (spot) => spot.paLatitude == latitude && spot.paLongitude == longitude);
    print('After index calculation, index: $index'); // Debug statement

    if (index != -1) {
      try {
        print('Before animateToPage'); // Debug statement
        pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        print('After animateToPage'); // Debug statement
      } catch (e) {
        print('Error during animateToPage: $e');
      }
    }

    void _reloadScreen(BuildContext context) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => IventDisplayScreen(
          category: widget.category,
          location: widget.location,
          price: widget.price,
          showMap: widget.showMap,
        ),
      ));
    }
  }
}

class InfoWindow extends StatelessWidget {
  final PlaceDetail selectedSpot;

  InfoWindow(this.selectedSpot);

  @override
  Widget build(BuildContext context) {
    print(selectedSpot.name);
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(selectedSpot.name!),
    );
  }
}
