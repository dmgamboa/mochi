import 'package:mochi/core/models/models.dart';
import 'package:mochi/features/chat/domain/models/enums.dart';

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

  String getSubtitle(String userId) {
    if (lastMessage == null) {
      return '';
    }

    final sender = lastMessage!.senderId == userId
        ? 'You'
        : participants.where((p) => p.id == lastMessage!.senderId).first.name;

    switch (lastMessage!.type) {
      case (MessageType.text):
        return '$sender: ${lastMessage!.content}';
      default:
        return '$sender sent an attachment.';
    }
  }
}
