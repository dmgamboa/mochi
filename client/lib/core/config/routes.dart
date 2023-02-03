import 'package:flutter/material.dart';
import 'package:mochi/features/chat/presentation/screens/chat_screen.dart';
import 'package:mochi/features/sample/presentation/sample.dart';

class Routes {
  static Map<String, Widget Function(Object?)> routes = {
    '/': (args) => const Sample(title: 'Sample'),
    '/chat': (args) => const ChatScreen()
  };

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('Error: Could not generate route'),
        ),
      ),
    );
  }

  static Route<dynamic> generate(RouteSettings settings) {
    final args = settings.arguments;
    final routeName = settings.name;
    final generator = routes[routeName];

    return generator != null
        ? MaterialPageRoute(builder: (_) => generator(args))
        : _errorRoute();
  }
}
