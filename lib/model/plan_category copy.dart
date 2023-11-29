class PlanCategory {
  final int id;
  final String name;

  PlanCategory({required this.id, required this.name});

  factory PlanCategory.fromJson(Map<String, dynamic> json) {
    return PlanCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}
