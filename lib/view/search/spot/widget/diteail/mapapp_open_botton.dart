import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';

class OpenMapsButton extends StatefulWidget {
  final String placeName;
  final double latitude;
  final double longitude;

  OpenMapsButton(
      {required this.placeName,
      required this.latitude,
      required this.longitude});

  @override
  _OpenMapsButtonState createState() => _OpenMapsButtonState();
}

class _OpenMapsButtonState extends State<OpenMapsButton> {
  LocationData? _currentLocation;
  final Location _location = Location();

  Future<void> _loadCurrentLocation() async {
    final currentLocation = await _location.getLocation();
    setState(() {
      _currentLocation = currentLocation;
    });
  }

  void openMapsSheet(BuildContext context) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                        onTap: () async {
                          // 現在地を更新
                          await _loadCurrentLocation();

                          // 現在地が利用可能な場合のみ処理を続行
                          if (_currentLocation != null) {
                            final mode =
                                await showModalBottomSheet<DirectionsMode>(
                              context: context,
                              builder: (BuildContext context) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: Text('徒歩'),
                                        onTap: () => Navigator.pop(
                                            context, DirectionsMode.walking),
                                      ),
                                      ListTile(
                                        title: Text('自転車'),
                                        onTap: () => Navigator.pop(
                                            context, DirectionsMode.bicycling),
                                      ),
                                      ListTile(
                                        title: Text('公共交通機関'),
                                        onTap: () => Navigator.pop(
                                            context, DirectionsMode.transit),
                                      ),
                                      ListTile(
                                        title: Text('車'),
                                        onTap: () => Navigator.pop(
                                            context, DirectionsMode.driving),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                            if (mode != null) {
                              // 現在地と目的地の座標を使用してマップを開く
                              await map.showDirections(
                                destination:
                                    Coords(widget.latitude, widget.longitude),
                                destinationTitle: widget.placeName,
                                origin: Coords(_currentLocation!.latitude!,
                                    _currentLocation!.longitude!),
                                directionsMode: mode,
                              );
                            }
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 58),
        GestureDetector(
          onTap: () => openMapsSheet(context),
          child: Container(
            height: 29,
            width: 109,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'マップで表示する',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
