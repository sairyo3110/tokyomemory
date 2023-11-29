class UserDatePlan {
  final int userId;
  final String planName;
  final DateTime date;

  UserDatePlan(
      {required this.userId, required this.planName, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'plan_name': planName,
      'date': date.toIso8601String(),
    };
  }
}
