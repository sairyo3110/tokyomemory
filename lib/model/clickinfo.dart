class ClickInfo {
  final int spotId;
  final String userId;
  final DateTime clickedAt;

  ClickInfo(
      {required this.spotId, required this.userId, required this.clickedAt});

  Map<String, dynamic> toJson() {
    return {
      'spot_id': spotId,
      'user_id': userId,
      'clicked_at': clickedAt.toIso8601String(),
    };
  }
}
