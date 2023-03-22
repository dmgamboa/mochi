import 'package:flutter/material.dart';
import '../domain/models/models.dart';
import './tabs/tabs.dart';

class Constants {
  static List<Map<String, dynamic>> tabs = [
    {
      'name': 'Friends',
      'icon': Icons.people,
      'widget': (args) => FriendsList(friends: args['friends']),
    },
    {
      'name': 'Reminders',
      'icon': Icons.notifications,
      'widget': (args) => const FriendReminders(),
    },
    {
      'name': 'Requests',
      'icon': Icons.person_add,
      'widget': (args) => FriendRequests(
            requests: args['requests'],
            onTabChanged: args['onRequestTabChanged'],
            onPressed: args['onRequestAction'],
          ),
    },
    {
      'name': 'Add Friend',
      'icon': Icons.add,
      'widget': (args) => AddFriend(
            searchResults: args['searchResults'],
            onSearch: args['onSearch'],
            onSendRequest: args['onSendRequest'],
          ),
    },
  ];

  static List<Map<String, dynamic>> requestTabs = [
    {
      'type': FriendRequestType.incoming,
      'name': 'Incoming',
      'icon': Icons.arrow_downward,
      'widget': (args) => IncomingRequests(
            requests: args['requests'],
            onAccept: args['onAccept'],
            onDecline: args['onDecline'],
          ),
    },
    {
      'type': FriendRequestType.outgoing,
      'name': 'Outgoing',
      'icon': Icons.arrow_upward,
      'widget': (args) => OutgoingRequests(
            requests: args['requests'],
            onCancel: args['onCancel'],
          ),
    },
  ];
}
