import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:mochi/core/models/models.dart';
import 'package:mochi/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:mochi/features/contacts/data/datasources/datasources.dart';
import 'package:mochi/features/contacts/data/respository/repository.dart';
import 'package:mochi/features/contacts/presentation/tabs/friends_list.dart';

class NewChatScreen extends StatefulWidget {
  static const String route = '/new_chat';

  const NewChatScreen({
    super.key,
  });

  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  List<User> friends = [];
  ChatRemoteDataSource source = ChatRemoteDataSource();

  @override
  void initState() {
    loadFriends();
    super.initState();
  }

  void onTap(User friend) {
    // source.getMessages(chat)
  }

  void loadFriends() async {
    final source = FriendsRemoteDataSource();
    final res = await source.getFriends();
    setState(() => friends = FriendsListRepository.fromServer(res));
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      pageTitle: 'New Chat',
      body: FriendsList(
        friends: friends,
        onTap: onTap,
      ),
      backBtn: true,
      navBar: false,
    );
  }
}
