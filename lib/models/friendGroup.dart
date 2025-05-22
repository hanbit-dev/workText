class FriendGroup {
  final int id;
  final String groupName;
  final String groupColor;
  final int? groupUserID;

  FriendGroup({
    required this.id,
    required this.groupName,
    required this.groupColor,
    required this.groupUserID,

  });

  factory FriendGroup.fromJson(Map<String, dynamic> json) {
    return FriendGroup(
      id: json['grp_id'],
      groupName: json['grp_nm'],
      groupColor: json['grp_color'],
      groupUserID: json['grpu_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'grp_nm': groupName,
      'grp_color': groupColor,
      'grpu_id': groupUserID,
    };
  }
}
