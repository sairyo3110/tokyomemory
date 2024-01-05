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

class PlaceCategorySub extends PlaceCategory {
  final int? placeId;
  final int parentCategoryId; // 親カテゴリーIDを追加

  PlaceCategorySub({
    required int categoryId,
    required String name,
    this.placeId,
    required this.parentCategoryId, // コンストラクタに追加
  }) : super(categoryId: categoryId, name: name);

  factory PlaceCategorySub.fromJson(Map<String, dynamic> json) {
    return PlaceCategorySub(
      categoryId: json['category_id'],
      name: json['name'],
      placeId: json['place_id'],
      parentCategoryId: json['parent_category_id'], // JSONから読み込む
    );
  }
}
