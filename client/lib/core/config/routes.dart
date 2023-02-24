import 'package:flutter/material.dart';
import 'package:mochi/features/chat/presentation/screens/chat_screen.dart';
import 'package:mochi/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:mochi/features/discover/presentation/screens/discover_screen.dart';
import 'package:mochi/features/events/presentation/screens/events_screen.dart';
import 'package:mochi/features/profile/presentation/screens/profile_creation_screen.dart';
import 'package:mochi/features/profile/presentation/screens/profile_screen.dart';
import 'package:mochi/features/auth/presentation/screens/signup_screen.dart';
import 'package:mochi/features/auth/presentation/screens/signin_screen.dart';

class Routes {
  static Map<String, Widget Function(Object?)> routes = {
    DiscoverScreen.route: (args) => const DiscoverScreen(),
    EventsScreen.route: (args) => const EventsScreen(),
    ChatScreen.route: (args) => const ChatScreen(),
    ContactsScreen.route: (args) => const ContactsScreen(),
    ProfileScreen.route: (args) => const ProfileScreen(),
    SignupScreen.route: (args) => const SignupScreen(),
    SigninScreen.route: (args) => const SigninScreen(),
    ProfileCreationScreen.route: (args) => const ProfileCreationScreen(),
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
        ? MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return generator(args);
            })
        : _errorRoute();
  }
}
