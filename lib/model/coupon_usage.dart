class CouponUsage {
  final int couponId;
  final String userId;
  final DateTime usedAt;

  CouponUsage(
      {required this.couponId, required this.userId, required this.usedAt});

  Map<String, dynamic> toJson() => {
        'coupon_id': couponId,
        'user_id': userId,
        'used_at': usedAt.toIso8601String(),
      };

  // 修正: JSONからCouponUsageオブジェクトを生成するための静的メソッド
  factory CouponUsage.fromJson(Map<String, dynamic> json) {
    final int couponId = json['coupon_id'];
    final String userId = json['user_id'];
    final DateTime usedAt = DateTime.parse(json['used_at']);
    return CouponUsage(couponId: couponId, userId: userId, usedAt: usedAt);
  }
}
