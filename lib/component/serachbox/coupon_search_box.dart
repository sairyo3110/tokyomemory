import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapapp/provider/places_provider.dart';
import 'package:mapapp/model/rerated_model.dart';

class CouponSearchBox extends StatefulWidget {
  final TextEditingController controller;

  CouponSearchBox({required this.controller});

  @override
  _CouponSearchBoxState createState() => _CouponSearchBoxState();
}

class _CouponSearchBoxState extends State<CouponSearchBox> {
  List<PlaceDetail> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounceTimer;
  late PlacesProvider _placesProvider;

  @override
  void initState() {
    super.initState();
    _placesProvider = PlacesProvider();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();

    super.dispose();
  }

  void _onSearch(String value) async {
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      if (value.trim().isEmpty) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        var places = await _placesProvider.fetchPlaceAllDetails('search',
            keyword: value);
        setState(() {
          _searchResults = places;
        });
      } catch (e) {
        print("Error fetching places: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    cursorColor: Color(0xFFF6E6DC), // カーソルの色
                    style: TextStyle(
                      color: Colors.white, // 入力されたテキストの色
                      // 他のスタイル設定もここに追加できます
                    ),
                    decoration: InputDecoration(
                      labelText: 'エリア・施設名・キーワード',
                      labelStyle: TextStyle(
                        color: Color(0xFFF6E6DC), // ラベル（プレースホルダー）の色
                      ),
                      suffixIcon: widget.controller.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  widget.controller.clear();
                                  _searchResults.clear();
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFF6E6DC)), // 通常の枠の色
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFF6E6DC)), // フォーカス時の枠の色
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFF6E6DC)), // 有効時の枠の色
                      ),
                      filled: true,
                      fillColor: Color(0xFF444440),
                    ),
                    onSubmitted: (value) => _onSearch(value),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (_isLoading) Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
