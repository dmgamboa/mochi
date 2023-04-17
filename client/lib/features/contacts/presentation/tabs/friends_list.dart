import 'package:flutter/material.dart';
import 'package:mochi/core/models/models.dart';
import '../widgets/widgets.dart';

class FriendsList extends StatelessWidget {
  final List<User> friends;
  final Function(User)? onTap;

  const FriendsList({
    required this.friends,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return friends.isEmpty
        ? const Center(child: Text('No friends yet :('))
        : ListView.builder(
            itemCount: friends.length,
            itemBuilder: (BuildContext context, int index) {
              return FriendsListElement(
                user: friends[index],
                onTap: onTap,
              );
            },
          );
  }
}
