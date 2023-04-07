import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:mochi/features/chat/data/repository/chat_repository.dart';
import '../../data/datasources/datasources.dart';
import '../../domain/models/models.dart';
import './chat_screen.dart';
import './new_chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  static const String route = '/chats';

  const ChatListScreen({
    super.key,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat> chats = [];
  ChatRemoteDataSource source = ChatRemoteDataSource();
  String? userId = '';

  @override
  void initState() {
    getChats();
    userId = firebase_auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    super.initState();
  }

  void getChats() async {
    final res = await source.getChats();
    setState(() => chats = ChatRepository.fromServer(res));
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Chats'),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, NewChatScreen.route),
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
                      chat.getTitle(userId!),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(chat.lastMessage!.createdAt.toString().substring(0, 10)),
                ],
              ),
              subtitle: chat.lastMessage!.type != MessageType.text
                  ? Text('${chat.participants[0].name} sent an attachment.')
                  : Text(
                      chat.lastMessage!.content,
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
