class User {
  String id;
  String name;
  String avatar;
  String statusMessage;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    this.statusMessage = '',
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['uid'] ?? json['id'],
        name = json['name'],
        avatar = json['profile_picture'] ?? json['avatar'] ?? '',
        statusMessage = json['display_message'] ?? json['statusMessage'] ?? '';

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'profile_picture': avatar,
      'display_message': statusMessage,
    };
  }

  static List<dynamic> encodeUsersList(List<User> userList) {
    return userList.map((user) => user.toJSON()).toList();
  }
}
