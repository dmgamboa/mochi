import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mochi/core/models/user.dart';
import 'package:mochi/core/utils/server_url.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:mochi/features/chat/data/repository/repository.dart';
import '../widgets/widgets.dart';
import '../../domain/models/models.dart';
import '../../data/datasources/datasources.dart';

class ChatScreenArgs {
  final Chat chat;

  ChatScreenArgs({
    required this.chat,
  });
}

class ChatScreen extends StatefulWidget {
  static const String route = '/chat';

  final ChatScreenArgs args;

  const ChatScreen({
    required this.args,
    super.key,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Message> messages;
  User? user;
  late socket_io.Socket socket;

  @override
  void initState() {
    super.initState();
    // TODO: Query chat from params
    final msgJson = widget.args.chat.participants.length == 2
        ? ChatMockData.directMessages
        : ChatMockData.groupMessages;
    messages = MessageRepository.fromMockData(msgJson);
    socket = socket_io.io(getServerUrl(), <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.connect();
    // TODO: Grab user id information from state
    user = User.fromJson(ChatMockData.users.first);
    socket.on('connection', (u) {
      // Handle connection
    });
    socket.on(
      'message',
      (res) => setState(() {
        final data = jsonDecode(res) as Map<String, dynamic>;
        if (data['sender'] != user?.toJSON()) {
          messages.add(MessageRepository.fromJson(data));
        }
      }),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void _sendMessage(String content, String? extension) {
    if (content.isNotEmpty) {
      final message = extension == null
          ? Message(
              id: '',
              sender: user!,
              content: content,
              createdAt: DateTime.now(),
            )
          : MediaMessage(
              id: '',
              sender: user!,
              content: content,
              extension: extension,
              createdAt: DateTime.now(),
            );
      socket.emit('message', MessageRepository.toJSON(message));
      setState(() => messages.add(message));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      pageTitle: 'Chat',
      navBar: false,
      backBtn: true,
      appBar: ChatHeader(
          title: widget.args.chat.getTitle(user!),
          fireCount: widget.args.chat.streak,
          avatar: 'https://picsum.photos/200?seed=1'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
        child: Column(
          children: [
            Expanded(
              child: user != null
                  ? ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[messages.length - 1 - index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ChatMessage(
                            fromSelf: message.sender.id == user!.id,
                            message: message,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            ChatField(onSend: _sendMessage)
          ],
        ),
      ),
    );
  }
}
