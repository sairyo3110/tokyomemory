import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapapp/colors.dart';

class CustomMarkerWidget extends StatelessWidget {
  final GlobalKey markerKey;

  CustomMarkerWidget({required this.markerKey});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -9999,
      top: -9999,
      child: RepaintBoundary(
        key: markerKey,
        child: Container(
          width: 50,
          height: 50,
          color: AppColors.primary,
          child: Center(
            child: Image.asset(
              'images/spot1.png',
              width: 45,
              height: 45,
            ),
          ),
        ),
      ),
    );
  }
}

Future<Uint8List> createMarkerImage(GlobalKey markerKey) async {
  RenderRepaintBoundary boundary =
      markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
