import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:mochi/core/models/user.dart';
import 'package:mochi/core/utils/server_url.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:mochi/features/chat/data/repository/repository.dart';
import 'package:mochi/core/models/models.dart' as mochi_models;
import '../widgets/widgets.dart';
import '../../domain/models/models.dart';
import '../../data/datasources/datasources.dart';

class ChatScreenArgs {
  Chat? chat;
  List<mochi_models.User>? participants;

  ChatScreenArgs({
    this.chat,
    this.participants,
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
  List<Message> messages = [];
  String? userId = '';
  late socket_io.Socket socket;
  ChatRemoteDataSource source = ChatRemoteDataSource();
  late Chat chat;

  @override
  void initState() {
    super.initState();
    userId = firebase_auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    if (widget.args.chat != null) {
      chat = widget.args.chat!;
      _getMessages();
      _setUpSockets();
    } else {
      chat = Chat(
        id: '',
        participants: widget.args.participants!,
      );
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void _setUpSockets(String id) {
    socket = socket_io.io(getServerUrl(), <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.connect();
    socket.on('connection', (u) {
      socket.emit('room', id);
    });
    socket.on(
      'message',
      (res) {
        final data = jsonDecode(res) as Map<String, dynamic>;
        if (data['user_id'] != userId) {
          setState(() => messages.add(MessageRepository.fromJson(data)));
        }
      },
    );
  }

  void _getMessages() async {
    final res = await source.getChatById(chat);
    List<Map<String, dynamic>> messagesJson = res['chat']['messages']
        .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
        .toList();
    setState(() => messages = MessageRepository.fromServer(messagesJson));
  }

  void _sendMessage(Message message) {
    final messageJSON = MessageRepository.toJSON(message);
    messageJSON['chat_id'] = chat.id;
    socket.emit('message', messageJSON);
  }

  void _createChat(Message message) async {
    final res = await source.newChat(message, chat.participants);
    final createdChat = ChatRepository.fromJson(res['chat']);
    setState(() => chat = createdChat);
    _setUpSockets(createdChat.id);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      pageTitle: 'Chat',
      navBar: false,
      backBtn: true,
      appBar: ChatHeader(
          title: chat.getTitle(userId!),
          fireCount: chat.streak,
          avatar: 'https://picsum.photos/200?seed=1'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
        child: Column(
          children: [
            Expanded(
              child: userId != null
                  ? ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[messages.length - 1 - index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ChatMessage(
                            fromSelf: message.senderId == userId,
                            message: message,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            ChatField(
              onSend: (c, e) {
                if (c.trim().isNotEmpty) {
                  final message = e == null
                      ? Message(
                          senderId: userId ?? '',
                          content: c,
                          type: MessageType.text,
                          createdAt: DateTime.now(),
                        )
                      : MediaMessage(
                          senderId: userId ?? '',
                          content: c,
                          extension: e,
                          type: MessageType.image,
                          createdAt: DateTime.now(),
                        );
                  if (chat.id == '') {
                    _createChat(message);
                  } else {
                    _sendMessage(message);
                  }
                  setState(() => messages.add(message));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
