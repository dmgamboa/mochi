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
        id: json['id'],
        sender: User.fromJson(json['sender']),
        content: json['content'],
        extension: json['extension'],
        createdAt: DateTime.parse(json['createdAt']),
      );
    } else {
      return Message(
        id: json['id'],
        sender: User.fromJson(json['sender']),
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
      );
    }
  }

  static Map<String, String> toJSON(Message message) {
    if (message is MediaMessage) {
      return {
        'sender': jsonEncode(message.sender.toJSON()),
        'content': message.content,
        'extension': message.extension,
        'read': message.read.toString(),
        'createdAt': message.createdAt.toString(),
      };
    } else {
      return {
        'sender': jsonEncode(message.sender.toJSON()),
        'content': message.content,
        'read': message.read.toString(),
        'createdAt': message.createdAt.toString(),
      };
    }
  }
}
