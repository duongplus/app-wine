class UserData {
  String phone;
  String displayName;
  String role;
  String avatar;
  String token;
  String point;

  UserData({this.phone,this.displayName, this.role, this.avatar, this.token, this.point});

  static UserData u = UserData();

  factory UserData.fromJson(Map<String, dynamic> map) {
    return UserData(
      phone: map['phone'],
      displayName: map['displayName'],
      role: map['role'],
      avatar: map['avatar'],
      token: map['token'],
      point: map['point'].toString(),
    );
  }

  static List<UserData> parseUserList(map) {
    var list = map as List;
    return list.map((user) => UserData.fromJson(user)).toList();
  }
}
