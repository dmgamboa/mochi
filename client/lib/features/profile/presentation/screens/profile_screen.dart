import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';

class ProfileScreen extends StatelessWidget {
  static const String route = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Layout(body: Text('Profile Screen'));
  }
}
