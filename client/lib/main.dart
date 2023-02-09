import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mochi/core/config/routes.dart';
import 'core/config/theme/light_theme.dart';

void main() {
  runApp(const ProviderScope(child: MochiApp()));
}

class MochiApp extends StatelessWidget {
  const MochiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: LightTheme.theme,
      onGenerateRoute: Routes.generate,
      initialRoute: '/discover',
    );
  }
}
