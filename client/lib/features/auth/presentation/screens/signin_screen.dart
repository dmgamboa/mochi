import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:mochi/features/auth/presentation/screens/signup_screen.dart';
import 'package:mochi/features/auth/presentation/widgets/header.dart';

import 'package:mochi/features/discover/presentation/screens/discover_screen.dart';
import 'package:mochi/features/profile/presentation/screens/profile_creation_screen.dart';

class SigninScreen extends StatefulWidget {
  static const String route = '/signin';

  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Layout(
        needsAuth: false,
        navBar: false,
        appBar: const AuthHeader(),
        body: Column(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Sign In',
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
              obscureText: true,
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
              onPressed: () => signInEmail(context),
              child: const Text('Sign In'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account?'),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(SignupScreen.route),
                child: const Text('Sign Up',
                    style: TextStyle(
                      color: Colors.blue,
                    )),
              ),
            ],
          ),
        ]));
  }

  signInEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);
      var url = Uri.parse('http://10.0.2.2:3000/login');
      var _headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenId',
      };
      var response = await http.get(url, headers: _headers);

      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
        content: Text(response.body),
        backgroundColor: Colors.green,
      ));
      log(tokenId);

      await Future.delayed(const Duration(seconds: 4));
      if (context.mounted) {
        Navigator.of(context).pushNamed(DiscoverScreen.route);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No user found for that email.'),
          backgroundColor: Colors.red,
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Wrong password provided for that user.'),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message!),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
