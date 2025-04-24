class Group {
  final int id;
  final String groupName;
  final String groupColor;
  final String createdAt;

  Group({
    required this.id,
    required this.groupName,
    required this.groupColor,
    required this.createdAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      groupName: json['grp_nm'],
      groupColor: json['grp_color'],
      createdAt: json['cret_dt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'grp_nm': groupName,
      'grp_color': groupColor,
      'cret_dt': createdAt,
    };
  }
}
