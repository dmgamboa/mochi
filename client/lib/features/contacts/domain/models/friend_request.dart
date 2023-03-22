import 'package:mochi/core/models/models.dart';

class FriendRequest {
  final User user;
  final DateTime dateSent;

  FriendRequest({
    required this.user,
    required this.dateSent,
  });
}
