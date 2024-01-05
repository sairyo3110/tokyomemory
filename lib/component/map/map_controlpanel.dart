import 'package:flutter/material.dart';

import 'package:mapapp/importer.dart';

class MapControlPanel extends StatelessWidget {
  final bool showMap;
  final TextEditingController searchController;
  final PlaceDetail? selectedPlace;
  final MapboxMapController? controller;
  final Function(bool) onToggleView;
  final Function(PlaceDetail?) onPlaceSelected;

  const MapControlPanel({
    Key? key,
    required this.showMap,
    required this.searchController,
    required this.selectedPlace,
    required this.controller,
    required this.onToggleView,
    required this.onPlaceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10.0,
      right: 10.0,
      child: Container(
        color: showMap ? Colors.transparent : Color(0xFF444440),
        child: Column(
          children: [
            SizedBox(height: 60),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: MapSearchBox(
                    controller: searchController,
                    onPlaceSelected: (selectedPlace) =>
                        onPlaceSelected(selectedPlace),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  mini: true,
                  onPressed: () => onToggleView(!showMap),
                  child: Icon(showMap ? Icons.list : Icons.map,
                      color: Colors.black),
                  backgroundColor: Color(0xFFF6E6DC),
                  tooltip: 'Toggle View',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
