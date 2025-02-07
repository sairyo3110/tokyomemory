class Couple {
  final int coupleId;
  final String user1Id;
  final String user2Id;
  final String anniversaryDate;
  final String createdAt;

  Couple({
    required this.coupleId,
    required this.user1Id,
    required this.user2Id,
    required this.anniversaryDate,
    required this.createdAt,
  });

  factory Couple.fromJson(Map<String, dynamic> json) {
    return Couple(
      coupleId: json['couple_id'],
      user1Id: json['user1_id'],
      user2Id: json['user2_id'],
      anniversaryDate: json['anniversary_date'],
      createdAt: json['created_at'],
    );
  }

  Couple copyWith({
    int? coupleId,
    String? user1Id,
    String? user2Id,
    String? anniversaryDate,
    String? createdAt,
  }) {
    return Couple(
      coupleId: coupleId ?? this.coupleId,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
