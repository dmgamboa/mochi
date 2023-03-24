import 'package:flutter/material.dart';
import 'package:mochi/core/models/models.dart';
import '../widgets/widgets.dart';

class FriendsList extends StatelessWidget {
  final List<User> friends;

  const FriendsList({
    required this.friends,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (BuildContext context, int index) {
        return FriendsListElement(user: friends[index]);
      },
    );
  }
}
