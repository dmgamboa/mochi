import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  String? _userId;
  late socket_io.Socket socket;

  @override
  void initState() {
    super.initState();
    socket = socket_io.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.connect();
    socket.on('connection', (id) {
      if (_userId == null) {
        setState(() {
          _userId = id;
        });
      }
    });
    socket.on(
        'message',
        (data) => setState(() {
              // Map<dynamic, dynamic> json = jsonDecode(data);
              if (data[0] != _userId) {
                _messages.add({
                  'sender': 'server',
                  'text': data[1],
                });
              }
            }));
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      String message = _textController.text;
      setState(() {
        _messages.add({
          'sender': 'user',
          'text': message,
        });
        socket.emit('message', {_userId, message});
        _textController.clear();
      });
    }
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[_messages.length - 1 - index];
              return Container(
                padding: const EdgeInsets.all(10),
                margin: message['sender'] == 'user'
                    ? const EdgeInsets.only(
                        left: 100,
                        right: 10,
                        bottom: 10,
                      )
                    : const EdgeInsets.only(
                        left: 10,
                        right: 100,
                        bottom: 10,
                      ),
                alignment: message['sender'] == 'user'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: message['sender'] == 'user'
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message['text'],
                  style: TextStyle(
                    color: message['sender'] == 'user'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Enter your message',
            ),
            onSubmitted: (value) => _sendMessage(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: _buildContent(context),
    );
  }
}
