import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:mochi/core/widgets/nav_bar/nav_bar_item.dart';
import 'package:mochi/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:mochi/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:mochi/features/discover/presentation/screens/discover_screen.dart';
import 'package:mochi/features/events/presentation/screens/events_screen.dart';
import 'package:mochi/features/profile/presentation/screens/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 2;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  static const Duration animDuration = Duration(milliseconds: 600);
  final List<NavBarItem> _items = [
    NavBarItem(
      icon: CupertinoIcons.chat_bubble_2,
      activeIcon: CupertinoIcons.chat_bubble_2_fill,
      route: ChatListScreen.route,
    ),
    NavBarItem(
      icon: Icons.calendar_month_outlined,
      activeIcon: Icons.calendar_month_rounded,
      route: EventsScreen.route,
    ),
    NavBarItem(
      icon: Icons.star_border_rounded,
      activeIcon: Icons.star_rate_rounded,
      route: DiscoverScreen.route,
    ),
    NavBarItem(
      icon: CupertinoIcons.person_3,
      activeIcon: CupertinoIcons.person_3_fill,
      route: ContactsScreen.route,
    ),
    NavBarItem(
      icon: CupertinoIcons.person_crop_circle,
      activeIcon: CupertinoIcons.person_crop_circle_fill,
      route: ProfileScreen.route,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    int page = _items
        .indexWhere((e) => e.route == ModalRoute.of(context)!.settings.name);
    if (page >= 0) {
      _page = page;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _page,
      color: Theme.of(context).primaryColor,
      buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).colorScheme.background,
      animationCurve: Curves.easeInOut,
      animationDuration: animDuration,
      onTap: (index) {
        setState(() {
          _page = index;
        });
        Future.delayed(animDuration,
            () => Navigator.pushNamed(context, _items[index].route));
      },
      letIndexChange: (index) => true,
      items: List.generate(
        _items.length,
        (index) => Icon(
          _page == index ? _items[index].activeIcon : _items[index].icon,
          size: 30,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
