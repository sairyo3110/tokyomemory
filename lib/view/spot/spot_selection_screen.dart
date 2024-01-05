import 'package:flutter/material.dart';
import 'package:mapapp/importer.dart';

class SpotSelectionScreen extends StatefulWidget {
  @override
  _SpotSelectionScreenState createState() => _SpotSelectionScreenState();
}

class _SpotSelectionScreenState extends State<SpotSelectionScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  TabController? _tabController;
  SpotSelectionViewModel? viewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    viewModel = SpotSelectionViewModel(provider: PlacesProvider());
    viewModel?.fetchCategories();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
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
                    SelectableList(
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
                      selectedOptions:
                          viewModel?.selectedLocations ?? [], // Nullチェックを追加
                      onOptionSelected: (value) {
                        setState(() {
                          viewModel?.updateSelectedLocations(value);
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    SelectableList(
                      title: '千代田区',
                      options: [
                        '神田',
                        '秋葉原',
                      ],
                      selectedOptions:
                          viewModel?.selectedLocations ?? [], // Nullチェックを追加
                      onOptionSelected: (value) {
                        setState(() {
                          viewModel?.updateSelectedLocations(value);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    SelectableList(
                      title: '中央区',
                      options: [
                        '銀座',
                        '築地',
                        '日本橋',
                        '京橋',
                      ],
                      selectedOptions:
                          viewModel?.selectedLocations ?? [], // Nullチェックを追加
                      onOptionSelected: (value) {
                        setState(() {
                          viewModel?.updateSelectedLocations(value);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    SelectableList(
                      title: '港区',
                      options: [
                        '六本木',
                        'お台場',
                        '品川',
                        '赤坂',
                      ],
                      selectedOptions:
                          viewModel?.selectedLocations ?? [], // Nullチェックを追加
                      onOptionSelected: (value) {
                        setState(() {
                          viewModel?.updateSelectedLocations(value);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    SelectableList(
                      title: '新宿区',
                      options: [
                        '新宿駅',
                        '歌舞伎町',
                      ],
                      selectedOptions:
                          viewModel?.selectedLocations ?? [], // Nullチェックを追加
                      onOptionSelected: (value) {
                        setState(() {
                          viewModel?.updateSelectedLocations(value);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    SelectableList(
                      title: '渋谷区',
                      options: [
                        '原宿',
                        '渋谷',
                      ],
                      selectedOptions:
                          viewModel?.selectedLocations ?? [], // Nullチェックを追加
                      onOptionSelected: (value) {
                        setState(() {
                          viewModel?.updateSelectedLocations(value);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    SelectableList(
                      title: '台東区',
                      options: [
                        '浅草',
                        '上野',
                      ],
                      selectedOptions:
                          viewModel?.selectedLocations ?? [], // Nullチェックを追加
                      onOptionSelected: (value) {
                        setState(() {
                          viewModel?.updateSelectedLocations(value);
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    SelectableList(
                      title: 'その他',
                      options: [
                        '国分寺',
                        '調布',
                      ],
                      selectedOptions:
                          viewModel?.selectedLocations ?? [], // Nullチェックを追加
                      onOptionSelected: (value) {
                        setState(() {
                          viewModel?.updateSelectedLocations(value);
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
                    PriceInput(
                      minPrice: viewModel!.minPrice ?? 0,
                      maxPrice: viewModel!.maxPrice ?? 20000,
                      onPriceChanged: (values) {
                        setState(() {
                          viewModel!.updatePriceRange(
                              values.start.toInt(), values.end.toInt());
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    FutureBuilder(
                      future: viewModel?.fetchCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // データが読み込まれた後にUIを構築
                          return CategorySelectionGrid(
                            categories: viewModel!.categories,
                            selectedCategoryIds: viewModel!.selectedCategoryIds,
                            onCategorySelected: (categoryId) {
                              setState(() {
                                viewModel!.updateSelectedCategories(categoryId);
                              });
                            },
                          );
                        } else {
                          // データが読み込まれるまでの間、ローディングインジケータを表示
                          return CircularProgressIndicator();
                        }
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
                      child: ActionButton(
                        text: '検索',
                        onPressed: () async {
                          await viewModel!.performSearch();
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpotDisplayScreen(
                                location:
                                    viewModel!.selectedLocations.join(', '),
                                price: viewModel!.priceRange ?? '',
                                category: viewModel!.selectedSubCategoryId
                                        ?.toString() ??
                                    '',
                                filteredPlaceIds: viewModel!.filteredPlaceIds,
                              ),
                            ),
                          );
                        },
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
                  TabBarContainer(
                    tabController: _tabController!,
                    tabLabels: ['場所で探す', '条件で探す'],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
