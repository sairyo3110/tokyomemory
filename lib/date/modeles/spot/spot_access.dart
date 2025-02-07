class PlaceAccess {
  final int id;
  final int placeId;
  final String nearestStation;
  final int walkingMinutes;

  PlaceAccess({
    required this.id,
    required this.placeId,
    required this.nearestStation,
    required this.walkingMinutes,
  });

  factory PlaceAccess.fromJson(Map<String, dynamic> json) {
    return PlaceAccess(
      id: json['id'],
      placeId: json['place_id'],
      nearestStation:
          json['nearest_station'] ?? 'Unknown Station', // nullチェックを追加
      walkingMinutes: json['walking_minutes'] ?? 0,
    );
  }
}
