import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapControllerProvider with ChangeNotifier {
  MapboxMapController? controller;

  void setMapController(MapboxMapController controller) {
    this.controller = controller;
    notifyListeners();
  }
}
