import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../features/auth/presentation/screens/signup_screen.dart';
import '../nav_bar/nav_bar.dart';

class Layout extends StatefulWidget {
  final bool needsAuth;
  final String? pageTitle;
  final bool customAppBarBg;
  final Widget? appBar;
  final Widget body;
  final bool backBtn;
  final bool navBar;

  const Layout({
    this.needsAuth = true,
    this.customAppBarBg = false,
    this.appBar,
    this.backBtn = false,
    this.navBar = true,
    this.pageTitle,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  User? user;
  @override
  void initState() {
    super.initState();
    if (widget.needsAuth) {
      user = FirebaseAuth.instance.currentUser;
      log(user.toString());
      if (user == null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed(SignupScreen.route);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: widget.backBtn
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : Container(),
        title: widget.appBar ?? Container(),
      ),
      body: Column(
        children: [
          Expanded(child: widget.body),
        ],
      ),
      bottomNavigationBar:
          widget.navBar ? const BottomNavBar() : const SizedBox(),
    );
  }
}
