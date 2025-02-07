class UserInfoRDB {
  final String? userId;
  final String? firebaseUserId;
  final String? email;
  final String? name;
  final String? prefecture;
  final String? birthday;
  final String? gender;
  final String? createdAt;

  UserInfoRDB({
    this.userId,
    this.firebaseUserId,
    this.email,
    this.name,
    this.prefecture,
    this.birthday,
    this.gender,
    this.createdAt,
  });

  factory UserInfoRDB.fromJson(Map<String, dynamic> json) {
    return UserInfoRDB(
      userId: json['user_id'].toString(),
      firebaseUserId: json['firebase_user_id'],
      email: json['email'],
      name: json['name'],
      prefecture: json['prefecture'],
      birthday: json['birthday'],
      gender: json['gender'],
      createdAt: json['created_at'],
    );
  }

  UserInfoRDB copyWith({
    String? userId,
    String? firebaseUserId,
    String? email,
    String? name,
    String? prefecture,
    String? birthday,
    String? gender,
    String? createdAt,
  }) {
    return UserInfoRDB(
      userId: userId ?? this.userId,
      firebaseUserId: firebaseUserId ?? this.firebaseUserId,
      email: email ?? this.email,
      name: name ?? this.name,
      prefecture: prefecture ?? this.prefecture,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
