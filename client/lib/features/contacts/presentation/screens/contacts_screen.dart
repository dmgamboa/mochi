import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:mochi/core/models/models.dart';

import 'package:mochi/core/widgets/layout/layout.dart';
import '../../data/datasources/datasources.dart';
import '../../data/respository/repository.dart';
import '../../domain/models/models.dart';
import '../../application/friends_service.dart';
import '../constants.dart';

class ContactsScreen extends StatefulWidget {
  static const route = '/contacts';

  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<User> friends = [];
  List<FriendRequest> requests = [];
  List<SearchResult> searchResults = [];
  late FriendsRemoteDataSource source;

  @override
  void initState() {
    super.initState();
    source = FriendsRemoteDataSource();
    getFriends();
    getRequests();
  }

  void getFriends() async {
    final res = FriendsListRepository.fromServer(await source.getFriends());
    setState(() => friends = res);
  }

  void getRequests() async {
    final res =
        FriendRequestsRepository.fromServer(await source.getIncomingRequests());
    setState(() => requests = res);
  }

  void onUserAction(UserActions action, User user) async {
    dynamic res;
    switch (action) {
      case UserActions.accept:
        res = await source.handleFriendRequest(user.id, true);
        setState(() => requests = FriendRequestsRepository.fromServer(res));
        break;
      case UserActions.decline:
        res = await source.handleFriendRequest(user.id, false);
        setState(() => requests = FriendRequestsRepository.fromServer(res));
        break;
      case UserActions.cancel:
        res = await source.cancelFriendRequest(user.id);
        setState(() => requests = FriendRequestsRepository.fromServer(res));
        break;
      case UserActions.request:
        await source.sendFriendRequest(user.id);
        break;
      default:
        break;
    }
  }

  void onRequestTabChanged(FriendRequestType type) async {
    final res = FriendRequestsRepository.fromServer(
        type == FriendRequestType.incoming
            ? await source.getIncomingRequests()
            : await source.getOutgoingRequests());
    setState(() => requests = res);
  }

  void onSearch(String query) async {
    if (query.trim() != '') {
      final res = await source.searchUsers(query);
      setState(() => searchResults = SearchResultsRepository.fromServer(res));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: DefaultTabController(
        length: Constants.tabs.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ButtonsTabBar(
                radius: 12.0,
                contentPadding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 4.0),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                unselectedBackgroundColor:
                    Theme.of(context).colorScheme.background,
                tabs: Constants.tabs
                    .map((e) => Tab(
                          text: e['name'],
                          icon: Icon(e['icon']),
                        ))
                    .toList()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TabBarView(
                  children: Constants.tabs
                      .map(
                        (e) => Container(
                          child: e['widget']({
                            'friends': friends,
                            'requests': requests,
                            'searchResults': searchResults,
                            'onSearch': onSearch,
                            'onRequestAction': onUserAction,
                            'onSendRequest': (user) =>
                                onUserAction(UserActions.request, user),
                            'onRequestTabChanged': onRequestTabChanged,
                          }),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
