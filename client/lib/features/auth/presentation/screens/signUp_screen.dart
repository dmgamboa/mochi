import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  static const String route = '/signup';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Layout(
        navBar: false,
        body: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Sign Up',
                style: TextStyle(
                  fontSize: 30,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                prefixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                  child: FaIcon(FontAwesomeIcons.solidEnvelope),
                ),
                border: UnderlineInputBorder(),
                labelText: 'email',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'email',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                prefixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                  child: FaIcon(FontAwesomeIcons.lock),
                ),
                border: UnderlineInputBorder(),
                labelText: 'password',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'password',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                prefixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(10, 12, 0, 0),
                  child: FaIcon(FontAwesomeIcons.lock),
                ),
                border: UnderlineInputBorder(),
                labelText: 'confirm password',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                hintText: 'confirm password',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          //sign up button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onPressed: () => signUpEmail(context),
              child: const Text('Sign Up'),
            ),
          ),
        ]));
  }

  signUpEmail(BuildContext context) {}
}
