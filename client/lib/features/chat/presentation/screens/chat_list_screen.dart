import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:mochi/features/chat/data/datasources/mock_data.dart';
import 'package:mochi/features/chat/data/repository/chat_repository.dart';
import '../../domain/models/models.dart';
import './chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  static const String route = '/chats';
  // final List<Chat> chats;

  ChatListScreen({
    // required this.chats,
    super.key,
  });

  final List<Chat> chats = ChatRepository.fromMockData(ChatMockData.chats);

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Chats'),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // TODO: Pull up Friends List
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ChatScreen.route,
                  arguments: ChatScreenArgs(chat: chat));
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    chat.participants[0].avatar,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      chat.getTitle(chat.participants[0]),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(chat.lastMessage.createdAt.toString().substring(0, 10)),
                ],
              ),
              subtitle: chat.lastMessage is MediaMessage
                  ? Text('${chat.participants[0].name} sent an attachment.')
                  : Text(
                      chat.lastMessage.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          );
        },
      ),
    );
  }
}
