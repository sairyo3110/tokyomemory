import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapapp/component/coupon_search_box.dart';
import 'package:mapapp/test/PlaceChategories.dart';
import 'package:mapapp/test/places_provider.dart';
import 'package:mapapp/test/rerated_model.dart';
import 'package:mapapp/view/coupon/coupon_selection_screen.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'coupon_detail_screen.dart';

class CouponListScreen extends StatefulWidget {
  final String location; // 選択された場所
  final String price; // 選択された価格範囲
  final String category; // 選択されたカテゴリーID
  CouponListScreen({
    required this.category,
    required this.location,
    required this.price,
  });

  @override
  _CouponListScreenState createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  List<PlaceDetail> coupons = [];
  List<PlaceDetail> filteredCoupons = [];
  String searchTerm = "";
  Position? _yourLocation;

  ScrollController _listScrollController = ScrollController();

  TextEditingController _searchController = TextEditingController();

  String _selectedLocation = '';
  int? _minPrice;
  int? _maxPrice;
  int? _selectedCategoryId;
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  List<PlaceCategory> _categories = [];
  bool _isLoadingCategories = true;

  bool _showFilter = true; // この変数でフィルタリング表示の表示/非表示を切り替えます。
  late VoidCallback _searchListener;

  final String endpoint = 'coupons';

  @override
  void initState() {
    super.initState();

    _getLocation().then((position) {
      setState(() {
        _yourLocation = position;
      });
    });

    fetchCoupons();
    _fetchCategories();
    _fetchCoupons();

    _listScrollController.addListener(() {
      if (_listScrollController.offset <= 0.0) {
        if (!_showFilter) {
          setState(() {
            _showFilter = true;
          });
        }
      } else if (_listScrollController.offset > 250.0) {
        if (_showFilter) {
          setState(() {
            _showFilter = false;
          });
        }
      }
    });

    _searchListener = () {
      setState(() {
        searchTerm = _searchController.text;
        _filterCoupons();
      });
    };
    _searchController.addListener(_searchListener);
  }

  fetchCoupons() async {
    try {
      PlacesProvider placesProvider = PlacesProvider(context);
      List<PlaceDetail> fetchedCoupons =
          await placesProvider.fetchPlaceAllDetails('coupons');
      setState(() {
        coupons = fetchedCoupons;
        if (coupons.isNotEmpty) {
          // クーポンが存在する場合のみフィルタリングを行う
          _filterSpots();
        } else {
          filteredCoupons = []; // クーポンが存在しない場合は空のリストをセット
        }
      });
    } catch (e) {
      print('Error fetching coupons: $e');
      // エラーハンドリングをここに追加
    }
  }

  Future<void> _fetchCoupons() async {}

  void _filterCoupons() {
    setState(() {
      filteredCoupons = coupons.where((coupon) {
        final bool matchesSearchTerm = searchTerm.isEmpty ||
            coupon.name!.toLowerCase().contains(searchTerm.toLowerCase());
        final int couponPrice =
            int.tryParse(coupon.nightMax?.toString() ?? '0') ?? 0;
        final bool matchesLocation = _selectedLocation.isEmpty ||
            coupon.address!.contains(_selectedLocation);
        final bool matchesCategory = _selectedCategoryId == null ||
            coupon.categoryId == _selectedCategoryId;
        final bool matchesPrice =
            (_minPrice != null && couponPrice >= _minPrice! ||
                    _minPrice == null) &&
                (_maxPrice != null && couponPrice <= _maxPrice! ||
                    _maxPrice == null);

        return matchesLocation &&
            matchesCategory &&
            matchesPrice &&
            matchesSearchTerm;
      }).toList();
    });
  }

  Future<void> _fetchCategories() async {
    try {
      var provider = PlacesProvider(context); // PlacesProvider のインスタンスを作成
      var categories = await provider.fetchPlaceCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (error) {
      print('Failed to load categories: $error');
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  void _filterSpots() {
    filteredCoupons.clear(); // フィルタリング前にリストをクリアする

    // すべてのフィルターが空である場合、全てのクーポンを表示します
    if (widget.category.isEmpty &&
        widget.location.isEmpty &&
        widget.price.isEmpty) {
      filteredCoupons = List.from(coupons);
    } else {
      filteredCoupons = coupons.where((coupon) {
        bool categoryMatch = true;
        bool locationMatch = true;
        bool priceMatch = true;

        // カテゴリIDに基づくフィルタリング
        if (widget.category.isNotEmpty) {
          try {
            int filterCategoryId = int.parse(widget.category);
            categoryMatch = coupon.categoryId == filterCategoryId;
          } catch (e) {}
        }

        // 位置に基づくフィルタリング
        if (widget.location.isNotEmpty) {
          locationMatch = coupon.address!.contains(widget.location);
        }

        // 価格に基づくフィルタリング
        if (widget.price.isNotEmpty) {
          try {
            RangeValues? priceRange = extractPriceRange(widget.price);
            if (priceRange != null) {
              int couponPrice = int.parse(coupon.nightMax as String);
              priceMatch = couponPrice >= priceRange.start &&
                  couponPrice <= priceRange.end;
            }
          } catch (e) {}
        }

        // すべての条件が満たされている場合のみ、クーポンをリストに追加する
        return categoryMatch && locationMatch && priceMatch;
      }).toList();
    }
  }

  Map<String, PlaceDetail> markerData = {};
  bool _showMap = false;
  PageController pageController = PageController();

  final String _style = 'mapbox://styles/enplace/cllwj4gw4007q01rf90r18bdh';
  final double _initialZoom = 10.5;

  MapboxMapController? controller;

  List<PlaceDetail> _filterCoupon(
      List<PlaceDetail> coupons, String searchTerm) {
    if (searchTerm.isEmpty) {
      return coupons;
    }
    return coupons
        .where((coupon) =>
            coupon.name!.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }

  void _navigateToCouponSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CouponSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                    this.controller = controller;
                    addImageAndMarkers();
                    controller.onSymbolTapped.add(_onSymbolTap);
                  },
                )
              : ListView.builder(
                  controller: _listScrollController, // ここを追加
                  padding: EdgeInsets.only(top: _showFilter ? 400.0 : 200.0),
                  itemCount: filteredCoupons.length, // ここを変更
                  itemBuilder: (BuildContext context, int index) {
                    final coupon = filteredCoupons[index]; // ここを変更
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CouponDetailScreen(coupon: coupon),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  10, // 画面の幅の半分
                              height: MediaQuery.of(context).size.width *
                                  0.5, // 16:9 aspect ratio での高さの半分
                              child: Image.network(
                                "https://mymapapp.s3.ap-northeast-1.amazonaws.com/coupon/${coupon.name}/1.png",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            child: Text(
                              coupon.name ?? '',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Icon(Icons.directions, size: 20.0),
                                SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                      ('${coupon.nearestStation}より ${coupon.walkingMinutes}分'),
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                              color: Colors
                                  .grey), // Add a divider for better visibility
                        ],
                      ),
                    );
                  },
                ),
          if (_showMap)
            Positioned(
              left: 0,
              right: 0,
              bottom: 3,
              height: MediaQuery.of(context).size.height * 0.3,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  controller?.animateCamera(CameraUpdate.newLatLng(LatLng(
                      coupons[value].paLatitude as double,
                      coupons[value].paLongitude as double)));
                },
                itemCount: filteredCoupons.length, // ここを変更
                itemBuilder: (_, index) {
                  final coupon = filteredCoupons[index]; // ここを変更
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CouponDetailScreen(coupon: coupon),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  "https://mymapapp.s3.ap-northeast-1.amazonaws.com/coupon/${coupon.name}/1.png",
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Positioned(
            left: 0.0,
            right: 0.0,
            child: Container(
              color: _showMap
                  ? Colors.transparent
                  : Color(0xFF444440), // _showMapがtrueの場合は透明な背景
              child: Column(
                children: [
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
                        child: CouponSearchBox(
                          controller: _searchController,
                        ),
                      ),
                      FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          setState(() {
                            _showMap = !_showMap;
                            if (_showMap) {
                              // もしマップを表示する場合
                              _showFilter = false; // フィルタリング画面を非表示にする
                            }
                          });
                        },
                        child: Icon(_showMap ? Icons.list : Icons.map),
                        tooltip: 'Toggle View',
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // 下部に余白を追加
                ],
              ),
            ),
          ),
          Positioned(
            top: 130.0,
            left: 0.0,
            right: 0.0,
            height: 270.0,
            child: _showFilter ? _buildFilterPanel() : _buildFilterIcon(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      color: Color(0xFF444440),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // 行の左端と右端にウィジェットを配置
              children: [
                Text('場所', style: TextStyle(fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showFilter = false; // フィルタリング表示を表示に切り替えます。
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 7.5, vertical: 2.5), // 横長のパディングを設定
                    decoration: BoxDecoration(
                      color: Color(0xFFF6E6DC), // 青色の背景
                      borderRadius: BorderRadius.circular(10.0), // 丸みを帯びた角
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.black, // 白いアイコン
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    buildSelectableList(
                      title: '',
                      options: [
                        '渋谷',
                        '池袋',
                        '新宿',
                        '浅草',
                        '押上',
                        '原宿',
                        '三軒茶屋',
                        '日本橋',
                        'お台場',
                        '銀座',
                        '吉祥寺',
                      ],
                      selectedOption: _selectedLocation,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildPriceInput(),
                    SizedBox(height: 20),
                    if (!_isLoadingCategories)
                      buildSelectableList(
                        title: 'カテゴリー',
                        options: _categories
                            .map((category) => category.name)
                            .toList(),
                        selectedOption: _categories
                            .firstWhere(
                                (category) =>
                                    category.categoryId == _selectedCategoryId,
                                orElse: () =>
                                    PlaceCategory(name: '', categoryId: -1))
                            .name,
                        onOptionSelected: (value) {
                          setState(() {
                            _selectedCategoryId = _categories
                                .firstWhere(
                                    (category) => category.name == value)
                                .categoryId;
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterIcon() {
    return Align(
      alignment: Alignment.topLeft, // 左上に配置
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0), // 適切なパディングを提供
        child: InkWell(
          onTap: () {
            setState(() {
              _showFilter = true; // フィルタリング表示を表示に切り替えます。
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 7.5, vertical: 2.5), // 横長のパディングを設定
            decoration: BoxDecoration(
              color: Color(0xFFF6E6DC), // 青色の背景
              borderRadius: BorderRadius.circular(10.0), // 丸みを帯びた角
            ),
            child: Icon(
              Icons.filter_list,
              color: Colors.black, // 白いアイコン
            ),
          ),
        ),
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

  Future<void> addImageAndMarkers() async {
    final ByteData bytes = await rootBundle.load('images/another_image.jpg');
    final Uint8List list = bytes.buffer.asUint8List();
    await controller?.addImage('marker-icon', list);

    for (int i = 0; i < filteredCoupons.length; i++) {
      addMarker(filteredCoupons[i]);
    }

    final LatLng newCenter = LatLng(35.6895, 139.6917);
    controller?.animateCamera(CameraUpdate.newLatLng(newCenter));
  }

  void addMarker(PlaceDetail coupons) {
    if (controller != null) {
      controller!
          .addSymbol(SymbolOptions(
        geometry:
            LatLng(coupons.paLatitude as double, coupons.paLongitude as double),
        iconImage: 'marker-icon',
        iconSize: 3.0,
      ))
          .then((symbol) {
        markerData[symbol.id] = coupons;
      });
    }
  }

  void _onSymbolTap(Symbol symbol) {
    final coupon = markerData[symbol.id];
    if (coupon != null) {
      _scrollToCard(coupon.place.latitude, coupon.place.longitude);
    }
  }

  void _scrollToCard(double latitude, double longitude) {
    final index = coupons.indexWhere((coupon) =>
        coupon.paLatitude == latitude && coupon.paLongitude == longitude);
    if (index != -1) {
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToCouponPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CouponSelectionScreen(),
      ),
    );
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

  Widget buildPriceInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('値段', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  int? selectedPrice = await _showPricePicker();
                  if (selectedPrice != null) {
                    setState(() {
                      _minPrice = selectedPrice;
                      _minPriceController.text = selectedPrice.toString();
                      _filterCoupons();
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _minPriceController,
                    decoration: InputDecoration(
                      labelText: '最小値',
                      labelStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text('〜', style: TextStyle()),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  int? selectedPrice = await _showPricePicker();
                  if (selectedPrice != null) {
                    setState(() {
                      _maxPrice = selectedPrice;
                      _maxPriceController.text = selectedPrice.toString();
                      _filterCoupons();
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _maxPriceController,
                    decoration: InputDecoration(
                      labelText: '最大値',
                      labelStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<int?> _showPricePicker() async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int selectedPrice = 0;
        return AlertDialog(
          title: Text('価格を選択'),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 51, // 0 to 50000 with an interval of 1000
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${index * 1000}円'),
                  onTap: () {
                    selectedPrice = index * 1000;
                    Navigator.of(context).pop(selectedPrice);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildSelectableList({
    required String title,
    required List<String> options,
    required String selectedOption,
    required ValueChanged<String> onOptionSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        SizedBox(
          height: 30.0, // この高さを調整して、表示される項目の高さを制御します
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 横にスクロールするように設定
            itemCount: options.length,
            itemBuilder: (context, index) {
              String option = options[index];
              bool isSelected = option == selectedOption;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    // 既に選択されている場合は、選択を解除
                    if (isSelected) {
                      if (title == '') {
                        _selectedLocation = '';
                      } else if (title == 'カテゴリー') {
                        _selectedCategoryId = null;
                      }
                    } else {
                      onOptionSelected(option);
                    }
                  });
                  _filterCoupons(); // この行を追加
                },
                child: Container(
                  margin: EdgeInsets.all(4.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0), // 横のパディングを追加
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
