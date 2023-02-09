import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';

class DiscoverScreen extends StatelessWidget {
  static const String route = '/discover';

  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Layout(body: Text('Discover Screen'));
  }
}
