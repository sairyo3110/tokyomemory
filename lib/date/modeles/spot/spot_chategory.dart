class PlaceCategory {
  final int categoryId;
  final String name;

  PlaceCategory({required this.categoryId, required this.name});

  factory PlaceCategory.fromJson(Map<String, dynamic> json) {
    return PlaceCategory(
      categoryId: json['category_id'],
      name: json['name'],
    );
  }
}

class SpotCategorySub {
  final int categoryId;
  final String name;
  final int? placeId;
  final int parentCategoryId;

  SpotCategorySub({
    required this.categoryId,
    required this.name,
    this.placeId,
    required this.parentCategoryId,
  });

  factory SpotCategorySub.fromJson(Map<String, dynamic> json) {
    return SpotCategorySub(
      categoryId: json['category_id'] as int,
      name: json['name'] as String,
      placeId: json['place_id'] as int?,
      parentCategoryId: json['parent_category_id'] as int,
    );
  }
}
