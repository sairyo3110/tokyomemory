class InviteCode {
  final int id;
  final String userId;
  final String code;
  final String createdAt;

  InviteCode(
      {required this.id,
      required this.userId,
      required this.code,
      required this.createdAt});

  factory InviteCode.fromJson(Map<String, dynamic> json) {
    return InviteCode(
      id: json['id'],
      userId: json['user_id'],
      code: json['code'],
      createdAt: json['created_at'],
    );
  }
}

class UsedInviteCode {
  final int inviteCodeId;
  final String inviteCode;
  final String userId;
  final String usedAt;
  final String createdAt;

  UsedInviteCode(
      {required this.inviteCodeId,
      required this.inviteCode,
      required this.userId,
      required this.usedAt,
      required this.createdAt});

  factory UsedInviteCode.fromJson(Map<String, dynamic> json) {
    return UsedInviteCode(
      inviteCodeId: json['InviteCodeID'],
      inviteCode: json['InviteCode'],
      userId: json['UserID'],
      usedAt: json['UsedAt'],
      createdAt: json['CreatedAt'],
    );
  }

  get code => null;
}
