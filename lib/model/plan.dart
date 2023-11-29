class DatePlan {
  final int planId;
  final int planCategoryId;
  final String planName;
  final int mainSpotId;
  final int lunchSpotId;
  final int subSpotId;
  final int cafeSpotId;
  final int dinnerSpotId;
  final int hotelSpotId;
  final String? planComment;
  final String? mainMemo;
  final String? lunchMemo;
  final String? subMemo;
  final String? cafeMemo;
  final String? dinnerMemo;
  final String? hotelMemo;
  final String? chategories;

  DatePlan({
    required this.planId,
    required this.planCategoryId,
    required this.planName,
    required this.mainSpotId,
    required this.lunchSpotId,
    required this.subSpotId,
    required this.cafeSpotId,
    required this.dinnerSpotId,
    required this.hotelSpotId,
    this.planComment,
    this.mainMemo,
    this.lunchMemo,
    this.subMemo,
    this.cafeMemo,
    this.dinnerMemo,
    this.hotelMemo,
    this.chategories,
  });

  factory DatePlan.fromJson(Map<String, dynamic> json) {
    return DatePlan(
      planId: json['plan_id'] as int,
      planCategoryId: json['plan_category_id'] as int,
      planName: json['plan_name'] as String,
      mainSpotId: json['main_spot_id'] as int,
      lunchSpotId: json['lunch_spot_id'] as int,
      subSpotId: json['sub_spot_id'] as int,
      cafeSpotId: json['cafe_spot_id'] as int,
      dinnerSpotId: json['dinner_spot_id'] as int,
      hotelSpotId: json['hotel_spot_id'] as int,
      planComment: json['plan_comment'] as String?,
      mainMemo: json['main_memo'] as String?,
      lunchMemo: json['lunch_memo'] as String?,
      subMemo: json['sub_memo'] as String?,
      cafeMemo: json['cafe_memo'] as String?,
      dinnerMemo: json['dinner_memo'] as String?,
      hotelMemo: json['hotel_memo'] as String?,
      chategories: json['chategories'] as String?,
    );
  }

  // ... 他のメソッドやプロパティ ...
}
