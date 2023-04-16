import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:mochi/core/config/routes.dart';
import 'package:mochi/features/chat/presentation/screens/chat_screen.dart';
import 'core/config/theme/light_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'features/splash/presentation/screens/splash.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'features/noti/notification_helper.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'lib/.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // noti initializer
  await NotificationHelper.init();
  // timezone initializer
  tz.initializeTimeZones();
  // this is the function that schedules the notification, here for testing purposes only
  NotificationHelper.scheduleNotification();
  runApp(const ProviderScope(child: MochiApp()));
}

class MochiApp extends StatelessWidget {
  const MochiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mochi',
      theme: LightTheme.theme,
      onGenerateRoute: Routes.generate,
      initialRoute: SplashScreen.route,
    );
  }
}
