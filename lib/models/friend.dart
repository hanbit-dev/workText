class Friend {
  final int id;
  final String friendNm;
  final String? grpNmColor;

  Friend({
    required this.id,
    required this.friendNm,
    this.grpNmColor,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['friend_id'],
      friendNm: json['friend_nm'],
      grpNmColor: json['grp_nm_color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friend_id': id,
      'friend_nm': friendNm,
      'grp_nm_color': grpNmColor,
    };
  }
}
