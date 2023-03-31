import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/config/colours.dart';

class UpdatePasswordScreen extends StatefulWidget {
  static const String route = '/update-password';
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final displayCurrentPasswordController = TextEditingController();
  final displayNewPasswordController = TextEditingController();
  final displayRePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Layout(
      navBar: false,
      appBar: AppBar(
        leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottomOpacity: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Update Password',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
                controller: displayCurrentPasswordController,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  return null;
                },
                controller: displayNewPasswordController,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Re-enter Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please re-enter your new password';
                  }
                  return null;
                },
                controller: displayRePasswordController,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
              ),
            ),
            buildUpdateBtn(context),
          ],
        ),
      ),
    );
  }

  Future<bool> validatePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    final credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: displayCurrentPasswordController.text,
    );
    try {
      await user.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return false;
      }
    }
    return false;
  }

  Future<void> validatePasswordController() async {
    final auth = await validatePassword();

    if (!auth) {
      // Firebase auth fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password incorrect, please try again'),
          backgroundColor: Colours.red,
        ),
      );
    } else {
      if (displayNewPasswordController.text.isNotEmpty && displayRePasswordController.text.isNotEmpty &&
      displayNewPasswordController.text == displayRePasswordController.text) {
          // Password auth and validation OK
        await FirebaseAuth.instance.currentUser!
            .updatePassword(displayNewPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated'),
            backgroundColor: Colours.green,
          ),
        );
      } else {
        // Firebase auth pass but validation fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New passwords do not match'),
            backgroundColor: Colours.red,
          ),
        );
      }
    }
  }

  Padding buildUpdateBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onPressed: () async {
            validatePasswordController();
          },
          child: const Text('Update Password'),
    ));
  }
}