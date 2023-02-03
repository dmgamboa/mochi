import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'sender': 'user',
          'text': _textController.text,
        });
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
              final message = _messages[index];
              return Container(
                padding: const EdgeInsets.all(10),
                margin: message['sender'] == 'user'
                    ? const EdgeInsets.only(
                        left: 100,
                        right: 10,
                      )
                    : const EdgeInsets.only(
                        left: 10,
                        right: 100,
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
