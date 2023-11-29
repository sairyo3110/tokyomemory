class ClickInfo2 {
  final int couponId;
  final String userId;
  final DateTime clickedAt;

  ClickInfo2(
      {required this.couponId, required this.userId, required this.clickedAt});

  Map<String, dynamic> toJson() {
    return {
      'coupon_id': couponId,
      'user_id': userId,
      'clicked_at': clickedAt.toIso8601String(),
    };
  }
}
