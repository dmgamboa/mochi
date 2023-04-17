import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mochi/features/auth/presentation/screens/signin_screen.dart';
import 'package:mochi/features/profile/presentation/screens/profile_creation_screen.dart';

import '../widgets/header.dart';

import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  static const String route = '/signup';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Layout(
        needsAuth: false,
        navBar: false,
        body: Column(children: [
          const AuthHeader(),
          const Padding(
            padding: EdgeInsets.all(0.0),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              obscureText: true,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(SigninScreen.route),
                child: const Text('Sign In',
                    style: TextStyle(
                      color: Colors.blue,
                    )),
              ),
            ],
          ),
          // GoogleRow(),
          // FacebookRow(),
          // TwitterRow(),
        ]));
  }

  signUpEmail(BuildContext context) async {
    try {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ));
        return;
      }
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      var tokenId = await FirebaseAuth.instance.currentUser!.getIdToken(true);
      var url = Uri.parse('http://10.0.2.2:3000/signup');
      var _headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenId',
      };
      var response = await http.get(url, headers: _headers);
      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
        content: Text(response.body),
        backgroundColor: Colors.green,
      ));

      await Future.delayed(const Duration(seconds: 5));
      if (context.mounted) {
        Navigator.of(context).pushNamed(ProfileCreationScreen.route);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The password provided is too weak.'),
          backgroundColor: Colors.red,
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'The account already exists for the email ${emailController.text}.'),
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message!),
          backgroundColor: Colors.red,
        ));
      }
    }
    // ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
    //   content: Text('Account created successfully'),
    // ));
    // Navigator.of(this.context)
    //     .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
    // if (context.mounted) Navigator.of(context).pushNamed(DiscoverScreen.route);
  }
}

class GoogleRow extends StatelessWidget {
  const GoogleRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Container(
          height: 50.0,
          width: 50.0,
          // color: Colors.blue,
          decoration: BoxDecoration(
              color: Colors.yellow, borderRadius: BorderRadius.circular(10.0)),
          child: IconButton(
            color: Colors.white,
            icon: const FaIcon(FontAwesomeIcons.squareGooglePlus),
            onPressed: () {},
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          height: 50.0,
          width: 250.0,
          decoration: BoxDecoration(
              color: Colors.yellow, borderRadius: BorderRadius.circular(10.0)),
          child: TextButton(
            child: const Text(
              'GOOGLE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    ]);
  }
}

class TwitterRow extends StatelessWidget {
  const TwitterRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Container(
          height: 50.0,
          width: 50.0,
          // color: Colors.blue,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10.0)),
          child: IconButton(
            color: Colors.white,
            icon: const FaIcon(FontAwesomeIcons.squareTwitter),
            onPressed: () {},
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          height: 50.0,
          width: 250.0,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10.0)),
          child: TextButton(
            child: const Text(
              'TWITTER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    ]);
  }
}

class FacebookRow extends StatelessWidget {
  const FacebookRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Container(
          height: 50.0,
          width: 50.0,
          // color: Colors.blue,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 70, 195),
              borderRadius: BorderRadius.circular(10.0)),
          child: IconButton(
            color: Colors.white,
            icon: const FaIcon(FontAwesomeIcons.squareFacebook),
            onPressed: () {},
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Container(
          height: 50.0,
          width: 250.0,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 70, 195),
              borderRadius: BorderRadius.circular(10.0)),
          child: TextButton(
            child: const Text(
              'FACEBOOK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    ]);
  }
}
