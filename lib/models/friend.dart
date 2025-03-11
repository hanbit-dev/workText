class Friend {
  final int id;
  final String friendNm;
  final String? grpNmColor;
  final String? grpNm;
  final String? friendHonor;
  final String? friendPosition;

  Friend({
    required this.id,
    required this.friendNm,
    this.grpNmColor,
    this.grpNm,
    this.friendHonor,
    this.friendPosition,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['friend_id'],
      friendNm: json['friend_nm'],
      grpNmColor: json['grp_nm_color'],
      grpNm: json['grp_nm'],
      friendHonor: json['honorifics_yn'],
      friendPosition: json['friend_position']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friend_id': id,
      'friend_nm': friendNm,
      'grp_nm_color': grpNmColor,
      'grp_nm': grpNm,
      'honorifics_yn': friendHonor,
      'friend_position': friendPosition,
    };
  }
}
