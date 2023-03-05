import '../../domain/models/models.dart';

class MessageRepository {
  static List<Message> fromMockData(List<Map<String, dynamic>> messages) {
    return messages.map((message) {
      if (message['extension'] != '') {
        return MediaMessage(
          id: message['id'],
          sender: message['sender'],
          content: message['content'],
          extension: message['extension'],
        );
      } else {
        return Message(
          id: message['id'],
          sender: message['sender'],
          content: message['content'],
        );
      }
    }).toList();
  }

  static Message fromJson(Map<String, dynamic> json) {
    if (json['extension'] != '') {
      return MediaMessage(
        id: json['id'],
        sender: json['sender'],
        content: json['content'],
        extension: json['extension'],
      );
    } else {
      return Message(
        id: json['id'],
        sender: json['sender'],
        content: json['content'],
      );
    }
  }

  static Map<String, String> toJSON(Message message) {
    if (message is MediaMessage) {
      return {
        'sender': message.sender,
        'content': message.content,
        'extension': message.extension,
      };
    } else {
      return {
        'sender': message.sender,
        'content': message.content,
      };
    }
  }
}
