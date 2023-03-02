import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mochi/core/config/typography.dart';
import 'package:mochi/core/utils/colours.dart';

import 'package:mochi/features/discover/presentation/screens/discover_screen.dart';
import 'package:mochi/features/onboarding/presentation/constants.dart';
import 'package:mochi/features/profile/presentation/screens/profile_creation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const String route = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushNamed(context, DiscoverScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      showDoneButton: false,
      showNextButton: false,
      globalHeader: Container(),
      globalFooter: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          margin: const EdgeInsets.only(bottom: 24.0),
          width: double.infinity,
          child: ElevatedButton(
            child: const Text('GET STARTED'),
            onPressed: () => _onIntroEnd(context),
          ),
        ),
      ),
      pages: OnboardingConstants.list
          .map(
            (i) => PageViewModel(
              useScrollView: false,
              titleWidget: Container(),
              bodyWidget: SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8),
                            child: SvgPicture.asset(
                              i['image']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: SvgPicture.asset(
                            'assets/graphics/slime_bg.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0,
                                  color: Colors.white,
                                ),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 0.0, 16.0, 100.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    i['heading']!,
                                    style: TextStyle(
                                      fontFamily: Fonts.heading,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w700,
                                      color: i['color']!,
                                    ),
                                  ),
                                  Text(
                                    i['description']!,
                                    style: const TextStyle(fontSize: 16.0),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              decoration: PageDecoration(
                bodyPadding: EdgeInsets.zero,
                contentMargin: EdgeInsets.zero,
                safeArea: 0,
                boxDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      i['color']!,
                      ColorUtils.darken(i['color']!, 0.2),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
