import './enums.dart';
import './message.dart';

class MediaMessage extends Message {
  final String extension;

  MediaMessage({
    required String senderId,
    required String content,
    required MessageType type,
    required this.extension,
    bool read = false,
    required DateTime createdAt,
  }) : super(
          senderId: senderId,
          content: content,
          read: read,
          createdAt: createdAt,
          type: type,
        );
}
