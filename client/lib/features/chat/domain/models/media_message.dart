import './message.dart';

class MediaMessage extends Message {
  final String extension;

  MediaMessage({
    required String id,
    required String sender,
    required String content,
    required this.extension,
  }) : super(
          id: id,
          sender: sender,
          content: content,
        );
}
