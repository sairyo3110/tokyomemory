import 'package:mapapp/importer.dart';

import 'package:http/http.dart' as http;

class MapboxMapComponent extends StatefulWidget {
  final String styleString;
  final double initialZoom;
  final Position? yourLocation;
  final List<PlaceDetail> spots;
  final PageController pageController; // 追加
  final Function(MapboxMapController)? onMapCreated; // 追加

  const MapboxMapComponent({
    Key? key,
    required this.styleString,
    required this.initialZoom,
    this.yourLocation,
    required this.spots,
    required this.pageController, // 追加
    this.onMapCreated,
  }) : super(key: key);

  @override
  _MapboxMapComponentState createState() => _MapboxMapComponentState();
}

class _MapboxMapComponentState extends State<MapboxMapComponent> {
  late MapboxMapController mapController;
  final Completer<MapboxMapController> _controller = Completer();

  PageController pageController = PageController();

  MapboxMapController? controller;

  late List<PlaceDetail> spots = [];

  PlaceDetail? _selectedPlace; // 選択されたPlaceを保存するための変数を追加

  Map<String, PlaceDetail> markerData = {};

  final double _initialZoom = 12.5;

  @override
  void initState() {
    super.initState();
    spots = widget.spots;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> addImageAndMarkers(
      MapboxMapController controller, List<PlaceDetail> spots) async {
    final defaultIconId = 'default-marker-icon';

    // デフォルト画像を読み込む
    final ByteData bytes = await rootBundle.load('images/another_image.jpg');
    final Uint8List defaultList = bytes.buffer.asUint8List();
    await controller.addImage(defaultIconId, defaultList);

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
              await controller.addImage(iconId, list);
            }
          } catch (e) {
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
    if (controller != null && spot.address!.isNotEmpty) {
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

  void _onSymbolTap(Symbol symbol) {
    final spot = markerData[symbol.id];
    if (spot != null) {
      _scrollToCard(spot.paLatitude ?? 0.0, spot.paLongitude ?? 0.0);
      _centerAndZoomOnMap(spot.paLatitude ?? 0.0, spot.paLongitude ?? 0.0);
    }
  }

  void _centerAndZoomOnMap(double latitude, double longitude) {
    controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15.0, // ここでズームレベルを設定します
        ),
      ),
    );
  }

  void _scrollToCard(double latitude, double longitude) {
    final index = spots.indexWhere(
        (spot) => spot.paLatitude == latitude && spot.paLongitude == longitude);
    if (index != -1) {
      widget.pageController
          .animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        print('スクロール完了: ${spots[index].name}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MapControllerProvider mapControllerProvider =
        Provider.of<MapControllerProvider>(context);
    return MapboxMap(
      styleString: widget.styleString,
      initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.yourLocation?.latitude ?? 35.6895,
            widget.yourLocation?.longitude ?? 139.6917,
          ),
          zoom: _initialZoom),
      myLocationEnabled: true,
      onMapCreated: (MapboxMapController controller) {
        widget.onMapCreated?.call(controller);
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
        _controller.future.then((mapboxMap) {
          mapboxMap.onSymbolTapped
              .add(_onSymbolTap); // シンボル（マーカー）がタップされたときのリスナーを追加
        });
        addImageAndMarkers(controller, widget.spots);
        this.controller = controller;
        mapControllerProvider.setMapController(controller);
        if (_selectedPlace != null) {
          controller.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(_selectedPlace!.paLatitude as double,
                  _selectedPlace!.paLongitude as double),
              16.0));
        }
      },
      onStyleLoadedCallback: () {
        addImageAndMarkers(controller!, widget.spots);
      },
    );
  }
}
