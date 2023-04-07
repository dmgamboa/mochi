import 'package:flutter/material.dart';
import 'package:mochi/core/utils/media_extensions.dart';
import '../../domain/models/models.dart';
import '../../../../core/widgets/media_preview/media_preview.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.fromSelf,
    required this.message,
  });

  final bool fromSelf;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: fromSelf ? Alignment.centerRight : Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: fromSelf ? Theme.of(context).primaryColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: message is MediaMessage
              ? MediaExtensions.isWebResource.hasMatch(message.content)
                  ? Image.network(message.content, fit: BoxFit.contain)
                  : MediaPreview(
                      source: message.content,
                      extension: (message as MediaMessage).extension,
                    )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(message.content),
                ),
        ),
      ),
    );
  }
}
