import 'package:mochi/core/models/models.dart';

import './message.dart';

class MediaMessage extends Message {
  final String extension;

  MediaMessage({
    required String id,
    required User sender,
    required String content,
    required this.extension,
    bool read = false,
    required DateTime createdAt,
  }) : super(
          id: id,
          sender: sender,
          content: content,
          read: read,
          createdAt: createdAt,
        );
}
