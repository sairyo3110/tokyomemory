import 'package:mapapp/date/modeles/spot/spot.dart';

class Plan {
  final int planId;
  final int planCategoryId;
  final String planName;
  final int mainSpotId;
  final int lunchSpotId;
  final int subSpotId;
  final int cafeSpotId;
  final int dinnerSpotId;
  final int hotelSpotId;
  final String? mainTime;
  final String? lunchTime;
  final String? subTime;
  final String? cafeTime;
  final String? dinnerTime;
  final String? hotelTime;
  final String? planComment;
  final String? mainMemo;
  final String? lunchMemo;
  final String? subMemo;
  final String? cafeMemo;
  final String? dinnerMemo;
  final String? hotelMemo;
  final String? chategories;
  String? categoryName; // 追加
  Spot? mainSpot;
  Spot? lunchSpot;
  Spot? subSpot;
  Spot? cafeSpot;
  Spot? dinnerSpot;
  Spot? hotelSpot;

  Plan({
    required this.planId,
    required this.planCategoryId,
    required this.planName,
    required this.mainSpotId,
    required this.lunchSpotId,
    required this.subSpotId,
    required this.cafeSpotId,
    required this.dinnerSpotId,
    required this.hotelSpotId,
    this.mainTime,
    this.lunchTime,
    this.subTime,
    this.cafeTime,
    this.dinnerTime,
    this.hotelTime,
    this.planComment,
    this.mainMemo,
    this.lunchMemo,
    this.subMemo,
    this.cafeMemo,
    this.dinnerMemo,
    this.hotelMemo,
    this.chategories,
    this.categoryName,
    this.mainSpot,
    this.lunchSpot,
    this.subSpot,
    this.cafeSpot,
    this.dinnerSpot,
    this.hotelSpot,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planId: json['plan_id'] as int,
      planCategoryId: json['plan_category_id'] as int,
      planName: json['plan_name'] as String,
      mainSpotId: json['main_spot_id'] as int,
      lunchSpotId: json['lunch_spot_id'] as int,
      subSpotId: json['sub_spot_id'] as int,
      cafeSpotId: json['cafe_spot_id'] as int,
      dinnerSpotId: json['dinner_spot_id'] as int,
      hotelSpotId: json['hotel_spot_id'] as int,
      mainTime: json['main_time'] as String?,
      lunchTime: json['lunch_time'] as String?,
      subTime: json['sub_time'] as String?,
      cafeTime: json['cafe_time'] as String?,
      dinnerTime: json['dinner_time'] as String?,
      hotelTime: json['hotel_time'] as String?,
      planComment: json['plan_comment'] as String?,
      mainMemo: json['main_memo'] as String?,
      lunchMemo: json['lunch_memo'] as String?,
      subMemo: json['sub_memo'] as String?,
      cafeMemo: json['cafe_memo'] as String?,
      dinnerMemo: json['dinner_memo'] as String?,
      hotelMemo: json['hotel_memo'] as String?,
      chategories: json['chategories'] as String?,
      categoryName: json['category_name'] as String?, // 追加
    );
  }

  void addSpotDetails(Spot mainSpot, Spot lunchSpot, Spot subSpot,
      Spot cafeSpot, Spot dinnerSpot, Spot hotelSpot) {
    this.mainSpot = mainSpot;
    this.lunchSpot = lunchSpot;
    this.subSpot = subSpot;
    this.cafeSpot = cafeSpot;
    this.dinnerSpot = dinnerSpot;
    this.hotelSpot = hotelSpot;
  }

  void addCategoryName(String name) {
    this.categoryName = name;
  }
}
