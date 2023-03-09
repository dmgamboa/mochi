import 'package:mochi/core/config/colours.dart';

class OnboardingConstants {
  static const List<Map<String, dynamic>> list = [
    {
      'heading': 'stick together',
      'description':
          'stick together with your friends by creating groups, chatting one-on-one, or planning time together using Chats!',
      'image': 'assets/graphics/onboarding/carousel_01.svg',
      'color': Colours.blueGreen,
    },
    {
      'heading': 'find time to chill',
      'description':
          'make new friends or reconnect with old friends who share similar interests with you safely and securely!',
      'image': 'assets/graphics/onboarding/carousel_02.svg',
      'color': Colours.green,
    },
    {
      'heading': 'flavours just for you',
      'description':
          'create new public events to meet with like-minded people, plan private events with friends, or find local events catered to your interests and your friends groups!',
      'image': 'assets/graphics/onboarding/carousel_03.svg',
      'color': Colours.purple,
    },
  ];
}
