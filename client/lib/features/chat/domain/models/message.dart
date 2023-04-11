import '../models/enums.dart';

class Message {
  final String senderId;
  final String content;
  final bool read;
  final DateTime createdAt;
  final MessageType type;

  Message({
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.type,
    this.read = false,
  });
}
