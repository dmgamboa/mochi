import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:mochi/features/chat/data/repository/repository.dart';
import '../widgets/widgets.dart';
import '../../domain/models/models.dart';
import '../../data/datasources/datasources.dart';

class ChatScreen extends StatefulWidget {
  static const String route = '/chat/:id';

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _messages = [];
  String? _userId;
  late socket_io.Socket socket;

  @override
  void initState() {
    super.initState();
    _userId = '1';
    _messages = MessageRepository.fromMockData(ChatMockData.directMessages);
    socket = socket_io.io(
        kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000',
        <String, dynamic>{
          'transports': ['websocket'],
        });
    socket.connect();
    socket.on('connection', (id) {
      setState(() {
        _userId = _userId ?? id;
      });
    });
    socket.on(
      'message',
      (res) => setState(() {
        final data = jsonDecode(res) as Map<String, dynamic>;
        if (data['sender'] != _userId) {
          _messages.add(MessageRepository.fromJson(data));
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
      // final message = extension == null
      //     ? Message(
      //         id: '',
      //         sender: _userId!,
      //         content: content,
      //         createdAt: DateTime.now(),
      //       )
      //     : MediaMessage(
      //         id: '',
      //         sender: _userId!,
      //         content: content,
      //         extension: extension,
      //         createdAt: DateTime.now(),
      //       );
      // socket.emit('message', MessageRepository.toJSON(message));
      // setState(() => _messages.add(message));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      pageTitle: 'Chat',
      navBar: false,
      backBtn: true,
      appBar: const ChatHeader(
          title: 'Alice, Bob',
          fireCount: 10,
          avatar: 'https://picsum.photos/200?seed=1'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
        child: Column(
          children: [
            Expanded(
              child: _userId != null
                  ? ListView.builder(
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[_messages.length - 1 - index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ChatMessage(
                            fromSelf: message.sender.id == _userId,
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
