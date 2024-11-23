class Friend {
  final int id;
  final String userId;
  final String friendNm;
  final String honorificsYn;
  final String friendPosition;
  final String prompt;
  final String cretDt;
  final String mdfyDt;

  Friend({
    required this.id,
    required this.userId,
    required this.friendNm,
    required this.honorificsYn,
    required this.friendPosition,
    required this.prompt,
    required this.cretDt,
    required this.mdfyDt,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      userId: json['user_id'],
      friendNm: json['friend_nm'],
      honorificsYn: json['honorifics_yn'],
      friendPosition: json['friend_position'],
      prompt: json['prompt'],
      cretDt: json['cret_dt'],
      mdfyDt: json['mdfy_dt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'friend_nm': friendNm,
      'honorifics_yn': honorificsYn,
      'friend_position': friendPosition,
      'prompt': prompt,
      'cret_dt': cretDt,
      'mdfy_dt': mdfyDt,
    };
  }
}
