import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';

class EventsScreen extends StatelessWidget {
  static const String route = '/events';

  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Layout(body: Text('Events Screen'));
  }
}
