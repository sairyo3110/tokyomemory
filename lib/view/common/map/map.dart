import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapapp/date/modeles/spot/spot.dart';
import 'package:mapapp/service/map/location_service.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart'; // 追加
import 'package:mapapp/view/common/map/marker_service.dart';
import 'package:mapapp/businesslogic/spot/spot_main.dart'; // 追加

class MapScreen extends StatefulWidget {
  final Function(Spot) onSpotSelected;
  final Spot? selectedSpot; // 追加

  MapScreen({required this.onSpotSelected, this.selectedSpot}); // 追加

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapboxMapController mapController;
  LocationData? _yourLocation;
  final LocationService locationService = LocationService();
  Map<String, Spot> symbolIdToSpot = {}; // マップピンのIDとスポット情報を関連付けるマップ

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    LocationData? locationData = await locationService.getLocation();
    setState(() {
      _yourLocation = locationData;
    });
  }

  void _onSpotSelected(Spot spot) {
    widget.onSpotSelected(spot); // コールバックを呼び出す
    // カメラを選択されたスポットの位置に移動
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(spot.paLatitude!, spot.paLongitude!),
        18.0, // ズームレベルを適切に設定
      ),
    );
  }

  @override
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSpot != widget.selectedSpot &&
        widget.selectedSpot != null) {
      // カメラを新しい選択されたスポットの位置に移動
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(widget.selectedSpot!.paLatitude!,
              widget.selectedSpot!.paLongitude!),
          18.0, // ズームレベルを適切に設定
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _yourLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Consumer<SpotViewModel>(
                  builder: (context, spotViewModel, child) {
                    return MapboxMap(
                      styleString:
                          'mapbox://styles/enplace/cllwj4gw4007q01rf90r18bdh',
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          _yourLocation!.latitude!,
                          _yourLocation!.longitude!,
                        ),
                        zoom: 15.0,
                      ),
                      myLocationEnabled: true,
                      onMapCreated: (MapboxMapController controller) {
                        setState(() {
                          mapController = controller;
                        });
                        // selectedSpotがある場合、その位置にズーム
                        if (widget.selectedSpot != null) {
                          controller.animateCamera(
                            CameraUpdate.newLatLngZoom(
                              LatLng(
                                widget.selectedSpot!.paLatitude!,
                                widget.selectedSpot!.paLongitude!,
                              ),
                              15.0, // 適切なズームレベルに設定
                            ),
                          );
                        }
                      },
                      onStyleLoadedCallback: () async {
                        final markerService = MarkerService(mapController);

                        await markerService
                            .addImageAndMarkers(spotViewModel.filteredSpots);
                        markerService.onSpotSelected = _onSpotSelected;
                        mapController.onSymbolTapped.add((symbol) {
                          final spot = markerService.markerData[symbol.id];
                          if (spot != null) {
                            markerService.onSpotSelected!(spot);
                          }
                        });

                        print('onStyleLoadedCallback called');
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }
}
