class Coupon {
  final int couponId;
  final int placeId;
  final String description;
  final String validUntil;
  final Places place;

  Coupon({
    required this.couponId,
    required this.placeId,
    required this.description,
    required this.validUntil,
    required this.place,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      couponId: json['coupon_id'] ?? 0,
      placeId: json['place_id'] ?? 0,
      description: json['description'] ?? "",
      validUntil: json['valid_until'] ?? "",
      place: Places.fromJson(json['place']),
    );
  }
}

class Places {
  final int placeId;
  final int categoryId;
  final String categoryName; // 新しいプロパティ
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
  final String access;
  final String businessHours;
  final String price;
  final String reservationSite;
  final String imageUrl;

  Places({
    required this.placeId,
    required this.categoryId,
    required this.categoryName, // 新しいプロパティ
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.access,
    required this.businessHours,
    required this.price,
    required this.reservationSite,
    required this.imageUrl,
  });

  factory Places.fromJson(Map<String, dynamic> json) {
    return Places(
      placeId: json['place_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? "", // 新しいプロパティを読み込む
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      latitude:
          double.tryParse(json['latitude'].toString()) ?? 0.0, // 文字列をdoubleに変換
      longitude:
          double.tryParse(json['longitude'].toString()) ?? 0.0, // 文字列をdoubleに変換
      description: json['description'] ?? "",
      access: json['access'] ?? "",
      businessHours: json['business_hours'] ?? "",
      price: json['price'] ?? "",
      reservationSite: json['reservation_site'] ?? "",
      imageUrl: json['image_url'] ?? "",
    );
  }

  get openHours => null;
}
