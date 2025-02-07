import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mapapp/date/modeles/spot/spot.dart';

class MarkerService {
  Map<String, Spot> markerData = {};
  MapboxMapController? controller;
  MarkerService(this.controller);
  Function(Spot)? onSpotSelected;

  void addMarker(Spot spot, String iconId, double iconSize) {
    if (controller != null && spot.address!.isNotEmpty) {
      controller!
          .addSymbol(SymbolOptions(
        geometry: LatLng(spot.paLatitude ?? 0.0, spot.paLongitude ?? 0.0),
        iconImage: iconId,
        iconSize: iconSize,
      ))
          .then((symbol) {
        markerData[symbol.id] = spot;
      });
    }
  }

  Future<void> addImageAndMarkers(List<Spot> spots,
      {double iconSize = 3.0}) async {
    final defaultIconId = 'default-marker-icon';

    // デフォルト画像を読み込む
    final ByteData bytes = await rootBundle.load('images/another_image.jpg');
    final Uint8List defaultList = bytes.buffer.asUint8List();
    await controller?.addImage(defaultIconId, defaultList);

    final client = http.Client();

    try {
      for (final spot in spots) {
        var iconId = defaultIconId; // デフォルトのアイコンIDを使用

        final imageUrl =
            'https://mymapapp.s3.ap-northeast-1.amazonaws.com/spot/${spot.placeId}/1.png';

        try {
          final response = await client.get(Uri.parse(imageUrl));

          if (response.statusCode == 200) {
            Uint8List list = response.bodyBytes;

            // 画像のサイズを変更して丸くトリミング
            img.Image? originalImage = img.decodeImage(list);
            if (originalImage != null) {
              img.Image resizedImage =
                  img.copyResize(originalImage, width: 50, height: 50);
              img.Image circularImage = _cropToCircle(resizedImage);
              list = Uint8List.fromList(img.encodePng(circularImage));
            }

            iconId = 'marker-icon-${spot.placeId}';
            await controller?.addImage(iconId, list);
          }
        } catch (e) {
          // エラーが発生した場合はデフォルトアイコンIDを使用
          print('Error downloading image: $e');
        }

        // マーカーを追加
        addMarker(spot, iconId, iconSize);
      }
    } finally {
      client.close();
    }
  }

  // 画像を丸くトリミングする関数
  img.Image _cropToCircle(img.Image squareImage) {
    final int size = squareImage.width;
    final img.Image mask = img.Image(size, size);
    final img.Image output = img.Image(size, size);

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        final int dx = x - size ~/ 2;
        final int dy = y - size ~/ 2;
        final int distance = dx * dx + dy * dy;
        if (distance <= (size ~/ 2) * (size ~/ 2)) {
          mask.setPixel(x, y, 0xFFFFFFFF);
        } else {
          mask.setPixel(x, y, 0x00000000);
        }
      }
    }

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        output.setPixel(x, y, squareImage.getPixel(x, y) & mask.getPixel(x, y));
      }
    }

    return output;
  }

  void onSymbolTap(Symbol symbol) {
    final spot = markerData[symbol.id];
    if (spot != null) {
      onSpotSelected!(spot);
    }
  }
}
