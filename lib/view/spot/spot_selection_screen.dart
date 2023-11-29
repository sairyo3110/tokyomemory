import 'package:flutter/material.dart';
import 'package:mapapp/component/search_box.dart';
import 'package:mapapp/test/PlaceChategories.dart';
import 'package:mapapp/test/places_provider.dart';
import 'package:mapapp/view/spot/spot_display_screen.dart';

class SpotSelectionScreen extends StatefulWidget {
  @override
  _SpotSelectionScreenState createState() => _SpotSelectionScreenState();
}

class _SpotSelectionScreenState extends State<SpotSelectionScreen>
    with SingleTickerProviderStateMixin {
  String _selectedLocation = '';
  int? _minPrice;
  int? _maxPrice;
  int? _selectedCategoryId;
  int? _selectedSubCategoryId;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  List<PlaceCategory> _categories = [];
  List<PlaceCategorySub> _categoriessub = []; // 修正: 型を PlaceCategorySub に変更
  bool _isLoadingCategories = true;
  bool _isLoadingCategoriessub = true;

  TabController? _tabController;
  String? subCategoryTitle44;
  String? subCategoryTitle45;
  String? subCategoryTitle46;
  String? subCategoryTitle47;
  String? subCategoryTitle48;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _tabController = TabController(vsync: this, length: 2);
  }

  Future<void> _fetchCategories() async {
    try {
      var provider = PlacesProvider(context); // PlacesProvider のインスタンスを作成
      var categories =
          await provider.fetchPlaceCategories(); // fetchPlaceCategories を呼び出す
      setState(() {
        _categories = categories.cast<PlaceCategory>();
        _isLoadingCategories = false;
        // ここで subCategoryTitle を設定
        subCategoryTitle44 = _categories
            .firstWhere((category) => category.categoryId == 44,
                orElse: () => PlaceCategory(categoryId: 44, name: ""))
            .name;
        subCategoryTitle45 = _categories
            .firstWhere((category) => category.categoryId == 45,
                orElse: () => PlaceCategory(categoryId: 45, name: ""))
            .name;
        subCategoryTitle46 = _categories
            .firstWhere((category) => category.categoryId == 46,
                orElse: () => PlaceCategory(categoryId: 46, name: ""))
            .name;
        subCategoryTitle47 = _categories
            .firstWhere((category) => category.categoryId == 47,
                orElse: () => PlaceCategory(categoryId: 47, name: ""))
            .name;
        subCategoryTitle48 = _categories
            .firstWhere((category) => category.categoryId == 48,
                orElse: () => PlaceCategory(categoryId: 48, name: ""))
            .name;
      });
      var categoriessub = await provider
          .fetchPlaceCategoriesSub(); // fetchPlaceCategoriesSub を呼び出す
      setState(() {
        _categoriessub = categoriessub.cast<PlaceCategorySub>(); // 修正: 型キャスト
        _isLoadingCategoriessub = false;
      });
    } catch (error) {
      print('Failed to load categories: $error');
      setState(() {
        _isLoadingCategories = false;
        _isLoadingCategoriessub = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          TabBarView(controller: _tabController, children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 150.0, left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    buildSelectableList(
                      title: '人気の場所',
                      options: [
                        "渋谷",
                        "新宿",
                        "池袋",
                        "吉祥寺",
                        "下北沢",
                        "浅草",
                        "高円寺",
                        "立川",
                        "日本橋",
                        "秋葉原",
                        "表参道",
                        "恵比寿",
                        "お台場"
                      ],
                      selectedOption: _selectedLocation,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                    buildSelectableList(
                      title: '千代田区',
                      options: [
                        '神田',
                        '秋葉原',
                      ],
                      selectedOption: _selectedLocation,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildSelectableList(
                      title: '中央区',
                      options: [
                        '銀座',
                        '築地',
                        '日本橋',
                        '京橋',
                      ],
                      selectedOption: _selectedLocation,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildSelectableList(
                      title: '港区',
                      options: [
                        '六本木',
                        'お台場',
                        '品川',
                        '赤坂',
                      ],
                      selectedOption: _selectedLocation,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildSelectableList(
                      title: '新宿区',
                      options: [
                        '新宿駅',
                        '歌舞伎町',
                      ],
                      selectedOption: _selectedLocation,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildSelectableList(
                      title: '渋谷区',
                      options: [
                        '原宿',
                        '渋谷',
                      ],
                      selectedOption: _selectedLocation,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildSelectableList(
                      title: '台東区',
                      options: [
                        '浅草',
                        '上野',
                      ],
                      selectedOption: _selectedLocation,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildSelectableList(
                      title: 'その他',
                      options: [
                        '国分寺',
                        '調布',
                      ],
                      selectedOption: _selectedLocation,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
                      },
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 130.0, left: 15.0, right: 15.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    buildPriceInput(),
                    SizedBox(height: 20),
                    Text("カテゴリー",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    if (!_isLoadingCategoriessub) SizedBox(height: 20),
                    buildSelectableListChategoriSub(
                      title: subCategoryTitle44 ?? 'デフォルトのタイトル', // ここを修正
                      options: _categoriessub
                          .where((category) => category.parentCategoryId == 44)
                          .map((category) => category.name)
                          .toList(),
                      selectedOption: _categoriessub
                          .firstWhere(
                              (category) =>
                                  category.categoryId ==
                                      _selectedSubCategoryId &&
                                  category.parentCategoryId == 44,
                              orElse: () => PlaceCategorySub(
                                  name: '',
                                  categoryId: -1,
                                  parentCategoryId: 44))
                          .name,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedSubCategoryId = _categoriessub
                              .firstWhere((category) =>
                                  category.name == value &&
                                  category.parentCategoryId == 44)
                              .categoryId;
                          _selectedCategoryId =
                              null; // サブカテゴリーを選択したらカテゴリーの選択をリセット
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildSelectableListChategoriSub(
                      title: subCategoryTitle45 ?? 'デフォルトのタイトル', // ここを修正
                      options: _categoriessub
                          .where((category) => category.parentCategoryId == 45)
                          .map((category) => category.name)
                          .toList(),
                      selectedOption: _categoriessub
                          .firstWhere(
                              (category) =>
                                  category.categoryId ==
                                      _selectedSubCategoryId &&
                                  category.parentCategoryId == 45,
                              orElse: () => PlaceCategorySub(
                                  name: '',
                                  categoryId: -1,
                                  parentCategoryId: 45))
                          .name,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedSubCategoryId = _categoriessub
                              .firstWhere((category) =>
                                  category.name == value &&
                                  category.parentCategoryId == 45)
                              .categoryId;
                          _selectedCategoryId =
                              null; // サブカテゴリーを選択したらカテゴリーの選択をリセット
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildSelectableListChategoriSub(
                      title: subCategoryTitle46 ?? 'デフォルトのタイトル', // ここを修正
                      options: _categoriessub
                          .where((category) => category.parentCategoryId == 46)
                          .map((category) => category.name)
                          .toList(),
                      selectedOption: _categoriessub
                          .firstWhere(
                              (category) =>
                                  category.categoryId ==
                                      _selectedSubCategoryId &&
                                  category.parentCategoryId == 46,
                              orElse: () => PlaceCategorySub(
                                  name: '',
                                  categoryId: -1,
                                  parentCategoryId: 46))
                          .name,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedSubCategoryId = _categoriessub
                              .firstWhere((category) =>
                                  category.name == value &&
                                  category.parentCategoryId == 46)
                              .categoryId;
                          _selectedCategoryId =
                              null; // サブカテゴリーを選択したらカテゴリーの選択をリセット
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildSelectableListChategoriSub(
                      title: subCategoryTitle47 ?? 'デフォルトのタイトル', // ここを修正
                      options: _categoriessub
                          .where((category) => category.parentCategoryId == 47)
                          .map((category) => category.name)
                          .toList(),
                      selectedOption: _categoriessub
                          .firstWhere(
                              (category) =>
                                  category.categoryId ==
                                      _selectedSubCategoryId &&
                                  category.parentCategoryId == 47,
                              orElse: () => PlaceCategorySub(
                                  name: '',
                                  categoryId: -1,
                                  parentCategoryId: 47))
                          .name,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedSubCategoryId = _categoriessub
                              .firstWhere((category) =>
                                  category.name == value &&
                                  category.parentCategoryId == 47)
                              .categoryId;
                          _selectedCategoryId =
                              null; // サブカテゴリーを選択したらカテゴリーの選択をリセット
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    buildSelectableListChategoriSub(
                      title: subCategoryTitle48 ?? 'デフォルトのタイトル', // ここを修正
                      options: _categoriessub
                          .where((category) => category.parentCategoryId == 48)
                          .map((category) => category.name)
                          .toList(),
                      selectedOption: _categoriessub
                          .firstWhere(
                              (category) =>
                                  category.categoryId ==
                                      _selectedSubCategoryId &&
                                  category.parentCategoryId == 48,
                              orElse: () => PlaceCategorySub(
                                  name: '',
                                  categoryId: -1,
                                  parentCategoryId: 48))
                          .name,
                      onOptionSelected: (value) {
                        setState(() {
                          _selectedSubCategoryId = _categoriessub
                              .firstWhere((category) =>
                                  category.name == value &&
                                  category.parentCategoryId == 48)
                              .categoryId;
                          _selectedCategoryId =
                              null; // サブカテゴリーを選択したらカテゴリーの選択をリセット
                        });
                      },
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ]),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Color(0xFF444440),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 240.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          print('Selected Location: $_selectedLocation');
                          print('Price Range: $_minPrice-$_maxPrice');
                          print(
                              'Selected Category ID: $_selectedSubCategoryId');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpotDisplayScreen(
                                location: _selectedLocation,
                                price: '$_minPrice-$_maxPrice',
                                category: '$_selectedSubCategoryId',
                              ),
                            ),
                          );
                        },
                        child: Text('検索'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF6E6DC), // ボタンの背景色
                          onPrimary: Colors.black, // ボタンのテキスト色
                          // 他にも影の色や形状などを設定できます
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Color(0xFF444440),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: SearchBox(
                            controller: _searchController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: Color(0xFFF6E6DC), // 文字色を黒に設定
                    indicatorColor: Color(0xFFF6E6DC), // インジケータの色を赤に設定
                    tabs: [
                      Tab(text: '場所で探す'),
                      Tab(text: '条件で探す'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget buildPriceInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('予算', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        RangeSlider(
          values: RangeValues(
              _minPrice?.toDouble() ?? 0, _maxPrice?.toDouble() ?? 20000),
          min: 0,
          max: 20000,
          divisions: 200,
          onChanged: (values) {
            setState(() {
              _minPrice = values.start.toInt();
              _maxPrice = values.end.toInt();
            });
          },
          labels: RangeLabels(
            '${_minPrice ?? 0}',
            '${_maxPrice ?? 20000}',
          ),
          activeColor: Color(0xFFF6E6DC), // アクティブな部分の色
          inactiveColor: Colors.grey, // 非アクティブな部分の色
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_minPrice ?? 0}円'),
            Text('${_maxPrice ?? 20000}円'),
          ],
        ),
      ],
    );
  }

  Widget buildSelectableListChategoriSub({
    required String title,
    required List<String> options,
    required String selectedOption,
    required ValueChanged<String> onOptionSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        Divider(),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3.0,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            final isSelected = option == selectedOption;
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedSubCategoryId = null;
                  } else {
                    onOptionSelected(option);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFF6E6DC) : Colors.transparent,
                  border: Border.all(
                    color: const Color.fromRGBO(224, 224, 224, 1),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Color(0xFFF6E6DC),
                  ),
                ),
              ),
            );
          },
        ),
      ],
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
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3.0,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            final isSelected = option == selectedOption;
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedLocation = '';
                  } else {
                    onOptionSelected(option);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFF6E6DC) : Colors.transparent,
                  border: Border.all(
                    color: const Color.fromRGBO(224, 224, 224, 1),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Color(0xFFF6E6DC),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
