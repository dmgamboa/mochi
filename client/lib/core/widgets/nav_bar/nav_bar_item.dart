import 'package:flutter/material.dart';

class NavBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String route;

  NavBarItem({
    required this.icon,
    this.activeIcon,
    required this.route,
  });
}
