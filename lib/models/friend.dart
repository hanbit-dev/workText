class Friend {
  final int id;
  final String friendNm;
  final String cretDt;

  Friend({
    required this.id,
    required this.friendNm,
    required this.cretDt,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      friendNm: json['friend_nm'],
      cretDt: json['cret_dt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'friend_nm': friendNm,
      'cret_dt': cretDt,
    };
  }
}
