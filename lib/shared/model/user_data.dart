class UserData {
  String displayName;
  String role;
  String avatar;
  String token;

  UserData({this.displayName, this.role, this.avatar, this.token});

  factory UserData.fromJson(Map<String, dynamic> map) {
    return UserData(
      displayName: map['displayName'],
      role: map['role'],
      avatar: map['avatar'],
      token: map['token'],
    );
  }
}
