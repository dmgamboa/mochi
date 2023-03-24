import 'dart:convert';

import 'package:mochi/core/models/models.dart';
import '../../domain/models/models.dart';
import './message_repository.dart';

class ChatRepository {
  static List<Chat> fromMockData(List<Map<String, dynamic>> chats) {
    return chats.map((chat) => fromJson(chat)).toList();
  }

  static Chat fromJson(Map<String, dynamic> json) {
    final user1 = User(
        avatar: 'https://picsum.photos/200?seed=1', id: '1', name: 'Brian');
    final user2 =
        User(avatar: 'https://picsum.photos/200?seed=2', id: '2', name: 'John');

    return Chat(
      id: json['id'],
      participants: json['participants']
          .map((x) => User.fromJson(x))
          .toList()
          .cast<User>(),
      lastMessage: MessageRepository.fromJson(json['lastMessage']),
      streak: int.parse(json['streak']),
    );
  }

  static Map<String, String> toJSON(Chat chat) {
    return {
      'id': chat.id,
      'participants': jsonEncode(chat.participants),
      'lastMessage': jsonEncode(MessageRepository.toJSON(chat.lastMessage)),
      'streak': chat.streak.toString(),
    };
  }
}
