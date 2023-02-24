import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';

class DiscoverScreen extends StatelessWidget {
  static const String route = '/discover';

  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Layout(
        body: Column(children: [
      const Text('Discover Screen'),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onPressed: () => signOut(context),
            child: const Text('Sign Out'),
          ))
    ]));
  }

  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushNamed(DiscoverScreen.route);
    }
  }
}
