import 'dart:convert';

import 'package:mochi/core/models/models.dart';

import '../../domain/models/models.dart';

class MessageRepository {
  static List<Message> fromMockData(List<Map<String, dynamic>> messages) {
    return messages.map((message) => fromJson(message)).toList();
  }

  static Message fromJson(Map<String, dynamic> json) {
    if (json['extension'] != '') {
      return MediaMessage(
        senderId: json['user_id'],
        content: json['content'] ?? json['message'] ?? '',
        extension: json['extension'] ?? '',
        createdAt: DateTime.parse(json['date']),
        type: MessageType.values.firstWhere(
          (e) => e.toString() == 'MessageType.${json['type']}',
        ),
      );
    } else {
      return Message(
        senderId: json['user_id'],
        content: json['content'] ?? json['message'] ?? '',
        createdAt: DateTime.parse(json['date']),
        type: MessageType.values.firstWhere(
          (e) => e.toString() == 'MessageType.${json['type']}',
        ),
      );
    }
  }

  static Map<String, String> toJSON(Message message) {
    return {
      'user_id': message.senderId,
      'content': message.content,
      'extension': message is MediaMessage ? message.extension : '',
      'type': message.type.toString().split('.').last,
      'read': message.read.toString(),
      'date': message.createdAt.toString(),
    };
  }
}
