class PlaceDetail {
  final int? placeId;
  final int? categoryId;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String? access;
  final String? businessHours;
  final String? price;
  final String? reservationSite;
  final String? imageUrl;
  final int? addressId;
  final int? subcategoryId;
  final int? hashtagId;
  final int? accessId;
  final int? hoursId;
  final int? priceId;
  final int? couponId;
  final int? id;
  final String? dayStart;
  final String? dayEnd;
  final String? nightStart;
  final String? nightEnd;
  final String? prefecture;
  final String? city;
  final String? chome;
  final String? banchi;
  final String? go;
  final String? buildingName;
  final double? paLatitude;
  final double? paLongitude;
  final int? cCouponId;
  final int? cPlaceId;
  final String? cDescription;
  final String? validUntil;
  final int? pcsCategoryId;
  final String? pcsName;
  final int? pcaId;
  final String? nearestStation;
  final int? walkingMinutes;
  final String? dayMin;
  final String? dayMax;
  final String? nightMin;
  final String? nightMax;

  PlaceDetail({
    this.placeId,
    this.categoryId,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.description,
    this.access,
    this.businessHours,
    this.price,
    this.reservationSite,
    this.imageUrl,
    this.addressId,
    this.subcategoryId,
    this.hashtagId,
    this.accessId,
    this.hoursId,
    this.priceId,
    this.couponId,
    this.id,
    this.dayStart,
    this.dayEnd,
    this.nightStart,
    this.nightEnd,
    this.prefecture,
    this.city,
    this.chome,
    this.banchi,
    this.go,
    this.buildingName,
    this.paLatitude,
    this.paLongitude,
    this.cCouponId,
    this.cPlaceId,
    this.cDescription,
    this.validUntil,
    this.pcsCategoryId,
    this.pcsName,
    this.pcaId,
    this.nearestStation,
    this.walkingMinutes,
    this.dayMin,
    this.dayMax,
    this.nightMin,
    this.nightMax,
  });

  factory PlaceDetail.fromJson(Map<String, dynamic> json) {
    return PlaceDetail(
      placeId: json['place_id'] as int?,
      categoryId: json['category_id'] as int?,
      name: json['name'] as String?,
      address: json['address'],
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      description: json['description'] as String?,
      access: json['access'] as String?,
      businessHours: json['business_hours'] as String?,
      price: json['price'] as String?,
      reservationSite: json['reservation_site'] as String?,
      imageUrl: json['image_url'] as String?,
      addressId: json['address_id'] as int?,
      subcategoryId: json['subcategory_id'] as int?,
      hashtagId: json['hashtag_id'] as int?,
      accessId: json['access_id'] as int?,
      hoursId: json['hours_id'] as int?,
      priceId: json['price_id'] as int?,
      couponId: json['coupon_id'] as int?,
      id: json['id'] as int?,
      dayStart: json['day_start'] as String?,
      dayEnd: json['day_end'] as String?,
      nightStart: json['night_start'] as String?,
      nightEnd: json['night_end'] as String?,
      prefecture: json['prefecture'] as String?,
      city: json['city'] as String?,
      chome: json['chome'] as String?,
      banchi: json['banchi'] as String?,
      go: json['go'] as String?,
      buildingName: json['building_name'] as String?,
      paLatitude: double.tryParse(json['pa.latitude'].toString()) ?? 0.0,
      paLongitude: double.tryParse(json['pa.longitude'].toString()) ?? 0.0,
      cCouponId: json['c.coupon_id'] as int?,
      cPlaceId: json['c.place_id'] as int?,
      cDescription: json['c.description'] as String?,
      validUntil: json['valid_until'] as String?,
      pcsCategoryId: json['pcs.category_id'] as int?,
      pcsName: json['pcs.name'] as String?,
      pcaId: json['pca.id'] as int?,
      nearestStation: json['nearest_station'] as String?,
      walkingMinutes: json['walking_minutes'] as int?,
      dayMin: json['day_min'] as String?,
      dayMax: json['day_max'] as String?,
      nightMin: json['night_min'] as String?,
      nightMax: json['night_max'] as String?,
    );
  }

  get categories => null;

  get place => null;

  bool _showInfoWindow = false;

  bool get showInfoWindow => _showInfoWindow;

  set showInfoWindow(bool value) {
    _showInfoWindow = value;
  }

  set distance(double distance) {}
}
