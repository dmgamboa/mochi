import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:mochi/core/config/colours.dart';
import 'package:mochi/core/models/models.dart';

import '../../domain/models/models.dart';
import '../constants.dart';

class FriendRequests extends StatelessWidget {
  final List<FriendRequest> requests;
  final Function(FriendRequestType) onTabChanged;
  final Function(UserActions, User) onPressed;

  const FriendRequests({
    required this.requests,
    required this.onTabChanged,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Constants.requestTabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ButtonsTabBar(
            radius: 12.0,
            contentPadding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 4.0),
            backgroundColor: Colours.blue,
            unselectedBackgroundColor: Theme.of(context).colorScheme.background,
            onTap: (i) => onTabChanged(
              Constants.requestTabs[i]['type'] as FriendRequestType,
            ),
            tabs: Constants.requestTabs
                .map((e) => Tab(
                      text: e['name'],
                      icon: Icon(e['icon']),
                    ))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: Constants.requestTabs
                  .map((e) => Container(
                          child: e['widget']({
                        'requests': requests,
                        'onAccept': (user) =>
                            onPressed(UserActions.accept, user),
                        'onDecline': (user) =>
                            onPressed(UserActions.decline, user),
                        'onCancel': (user) =>
                            onPressed(UserActions.cancel, user),
                      })))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
