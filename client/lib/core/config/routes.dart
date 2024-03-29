import 'package:flutter/material.dart';
import 'package:mochi/features/chat/presentation/screens/new_chat_screen.dart';
import 'package:mochi/features/chat/presentation/screens/chat_screen.dart';
import 'package:mochi/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:mochi/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:mochi/features/discover/presentation/screens/discover_screen.dart';
import 'package:mochi/features/events/presentation/screens/event_screen.dart';
import 'package:mochi/features/events/presentation/screens/events_screen.dart';
import 'package:mochi/features/events/presentation/screens/event_creation_screen.dart';
import 'package:mochi/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:mochi/features/profile/presentation/screens/profile_creation_screen.dart';
import 'package:mochi/features/profile/presentation/screens/profile_screen.dart';
import 'package:mochi/features/auth/presentation/screens/signup_screen.dart';
import 'package:mochi/features/auth/presentation/screens/signin_screen.dart';
import 'package:mochi/features/splash/presentation/screens/splash.dart';
import 'package:mochi/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:mochi/features/profile/presentation/screens/update_password_screen.dart';

class Routes {
  static Map<String, Widget Function(Object?)> routes = {
    SplashScreen.route: (args) => const SplashScreen(),
    OnboardingScreen.route: (args) => const OnboardingScreen(),
    DiscoverScreen.route: (args) => const DiscoverScreen(),
    EventScreen.route: (args) => EventScreen(args: args as EventScreenArgs),
    EventsScreen.route: (args) => const EventsScreen(),
    EventCreationScreen.route: (args) => const EventCreationScreen(),
    ChatScreen.route: (args) => ChatScreen(args: args as ChatScreenArgs),
    ChatListScreen.route: (args) => ChatListScreen(),
    NewChatScreen.route: (args) => const NewChatScreen(),
    ContactsScreen.route: (args) => const ContactsScreen(),
    SigninScreen.route: (args) => const SigninScreen(),
    SignupScreen.route: (args) => const SignupScreen(),
    ProfileScreen.route: (args) => const ProfileScreen(),
    ProfileCreationScreen.route: (args) => const ProfileCreationScreen(),
    EditProfileScreen.route: (args) => const EditProfileScreen(),
    UpdatePasswordScreen.route: (args) => const UpdatePasswordScreen(),
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
        ? PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, anim1, anim2) => generator(args),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          )
        : _errorRoute();
  }
}
