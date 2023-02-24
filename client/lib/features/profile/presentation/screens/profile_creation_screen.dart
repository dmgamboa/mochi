import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mochi/core/widgets/layout/layout.dart';

import '../../../discover/presentation/screens/discover_screen.dart';

class ProfileCreationScreen extends StatefulWidget {
  static const String route = '/profile_creation';

  const ProfileCreationScreen({Key? key}) : super(key: key);

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  // final _formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Layout(
        // needsAuth: false,
        navBar: false,
        // body: Form(
        //     key: _formKey,
        //     child: Column(children: const [
        //       Padding(
        //         padding: EdgeInsets.all(8.0),
        //         child: Text('Create your profile',
        //             style: TextStyle(
        //               fontSize: 30,
        //             )),
        //       ),
        body: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Create your profile',
                style: TextStyle(
                  fontSize: 30,
                )),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: Center(child: FaIcon(FontAwesomeIcons.circleUser)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 0, 0),
            child: FaIcon(FontAwesomeIcons.pencil),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              controller: displayNameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                prefixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                  child: FaIcon(FontAwesomeIcons.solidEnvelope),
                ),
                border: UnderlineInputBorder(),
                labelText: 'Display Name',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'Display Name',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextFormField(
              autofocus: false,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Display Message',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'Display Message',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFFF2F2F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1),
                ),
              ),
            ),
          ),
          //sign out button
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
