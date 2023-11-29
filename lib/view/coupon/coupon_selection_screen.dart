import 'package:flutter/material.dart';
import 'package:mapapp/test/PlaceChategories.dart';
import 'package:mapapp/test/places_provider.dart';
import 'package:mapapp/test/rerated_model.dart';

class CouponSelectionScreen extends StatefulWidget {
  @override
  _CouponSelectionScreenState createState() => _CouponSelectionScreenState();
}

class _CouponSelectionScreenState extends State<CouponSelectionScreen> {
  String _selectedLocation = '';
  int? _minPrice;
  int? _maxPrice;
  int? _selectedCategoryId;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  List<PlaceDetail> _coupons = []; // 元のクーポンデータ
  List<PlaceDetail> _filteredCoupons = []; // フィルタリングされたクーポンデータ

  List<PlaceCategory> _categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    _fetchCategories();
    _fetchCoupons(); // 初期化時にクーポンデータを取得
    super.initState();
  }

  Future<void> _fetchCoupons() async {
    // ここでクーポンデータを取得し、_coupons変数に保存します
    // 例: _coupons = await CouponProvider().fetchCoupons();
  }

  void _filterCoupons() {
    // ここで_selectedLocation, _minPrice, _maxPrice, および_selectedCategoryIdを使用してクーポンをフィルタリング
    setState(() {
      _filteredCoupons = _coupons.where((coupon) {
        final int couponPrice = int.tryParse(coupon.nightMax as String) ?? 0;
        final bool matchesLocation =
            _selectedLocation.isEmpty || coupon.address == _selectedLocation;
        final bool matchesCategory = _selectedCategoryId == null ||
            coupon.categoryId == _selectedCategoryId;
        final bool matchesPrice =
            (couponPrice >= _minPrice! || _minPrice == null) &&
                (couponPrice <= _maxPrice! || _maxPrice == null);
        return matchesLocation && matchesCategory && matchesPrice;
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

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSelectableList(
                  title: '場所',
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
                    options:
                        _categories.map((category) => category.name).toList(),
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
                            .firstWhere((category) => category.name == value)
                            .categoryId;
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPriceInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('値段', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(height: 0),
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '最小値',
                  labelStyle: TextStyle(fontSize: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _minPrice = int.tryParse(value);
                  });
                },
              ),
            ),
            SizedBox(width: 10),
            Text('〜', style: TextStyle()),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                style: TextStyle(height: 0),
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '最大値',
                  labelStyle: TextStyle(fontSize: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _maxPrice = int.tryParse(value);
                  });
                },
              ),
            ),
          ],
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
                      if (title == '場所') {
                        _selectedLocation = '';
                      } else if (title == 'カテゴリー') {
                        _selectedCategoryId = null;
                      }
                    } else {
                      onOptionSelected(option);
                    }
                  });
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
