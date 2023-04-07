import 'package:mochi/core/models/models.dart';

import './message.dart';

class Chat {
  final String id;
  final List<User> participants;
  final Message? lastMessage;
  final int streak;
  String title;

  Chat({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.streak = 0,
    this.title = '',
  });

  String getTitle(String userId) {
    if (title.isNotEmpty) {
      return title;
    }

    final otherParticipants =
        participants.where((p) => p.id != userId).toList();
    if (otherParticipants.length == 1) {
      return otherParticipants.first.name;
    }

    return otherParticipants.map((p) => p.name).join(', ');
  }
}
