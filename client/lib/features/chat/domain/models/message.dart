import 'package:mochi/core/models/models.dart';

class Message {
  final String id;
  final User sender;
  final String content;
  final bool read;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sender,
    required this.content,
    required this.createdAt,
    this.read = false,
  });
}
