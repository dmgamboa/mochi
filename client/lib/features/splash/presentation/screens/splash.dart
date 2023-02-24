import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mochi/features/onboarding/presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String route = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Duration splashDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    Future.delayed(splashDuration, () {
      // TODO: Redirect to either onboarding or login
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.3),
              Theme.of(context).primaryColor.withOpacity(0.7),
              Theme.of(context).primaryColor,
            ],
            stops: const [0.2, 0.6, 1],
          ),
        ),
        child: Center(
            child: Container(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset('assets/brand/logo.svg'),
        )),
      ),
    );
  }
}
