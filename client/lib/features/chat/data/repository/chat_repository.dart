import 'dart:convert';

import 'package:mochi/core/models/models.dart';
import '../../domain/models/models.dart';
import './message_repository.dart';

class ChatRepository {
  static List<Chat> fromServer(List<Map<String, dynamic>> chats) {
    return chats.map((chat) => fromJson(chat)).toList();
  }

  static Chat fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['chat']['_id'],
      participants: json['participants']
          .map((x) => User.fromJson(x))
          .toList()
          .cast<User>(),
      lastMessage: MessageRepository.fromJson(json['last_message']),
      streak: 0,
    );
  }

  static Map<String, String> toJSON(Chat chat) {
    return {
      'id': chat.id,
      'participants': jsonEncode(chat.participants),
      'last_message': jsonEncode(MessageRepository.toJSON(chat.lastMessage!)),
      // 'streak': chat.streak.toString(),
    };
  }
}
