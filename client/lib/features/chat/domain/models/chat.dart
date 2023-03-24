import 'package:mochi/core/models/models.dart';

import './message.dart';

class Chat {
  final String id;
  final List<User> participants;
  final Message lastMessage;
  final int streak;
  String title;

  Chat({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.streak,
    this.title = '',
  });

  String getTitle(User user) {
    if (title.isNotEmpty) {
      return title;
    }

    final otherParticipants =
        participants.where((p) => p.id != user.id).toList();
    if (otherParticipants.length == 1) {
      return otherParticipants.first.name;
    }

    return otherParticipants.map((p) => p.name).join(', ');
  }
}
