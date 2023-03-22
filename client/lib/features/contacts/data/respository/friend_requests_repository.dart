import 'package:mochi/core/models/models.dart';
import '../../domain/models/models.dart';

class FriendRequestsRepository {
  static List<FriendRequest> fromMockData(List<Map<String, dynamic>> requests) {
    return requests
        .map(
          (e) => FriendRequest(
            user: User.fromJson(e['user']),
            dateSent: DateTime.parse(e['dateSent']),
          ),
        )
        .toList();
  }

  static List<FriendRequest> fromServer(List<Map<String, dynamic>> requests) {
    return requests
        .map(
          (e) => FriendRequest(
            user: User.fromJson(e['user']),
            dateSent: DateTime.parse(e['date']),
          ),
        )
        .toList();
  }
}
