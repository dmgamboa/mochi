import 'package:mochi/core/models/models.dart';

class FriendsListRepository {
  static List<User> fromMockData(List<Map<String, dynamic>> users) {
    return users.map((e) => User.fromJson(e)).toList();
  }

  static List<User> fromServer(List<Map<String, dynamic>> users) {
    return users.map((e) => User.fromJson(e)).toList();
  }
}
