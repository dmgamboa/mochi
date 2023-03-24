import 'package:mochi/core/models/models.dart';

import './message.dart';

class Chat {
  final String id;
  final List<User> participants;
  final Message lastMessage;
  final int streak;

  Chat({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.streak,
  });
}
