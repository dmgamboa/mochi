import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path_drawing/path_drawing.dart';

import '../../../features/auth/presentation/screens/signup_screen.dart';
import '../nav_bar/nav_bar.dart';

import 'slime.dart';

class Layout extends StatefulWidget {
  final bool needsAuth;
  final String? pageTitle;
  final Widget? pageTitleWidget;
  final Widget? appBar;
  final Color? appBarBg;
  final Widget body;
  final bool backBtn;
  final bool navBar;
  final Function()? onBackPressed;
  final double height;

  const Layout({
    this.needsAuth = true,
    this.appBar,
    this.appBarBg,
    this.backBtn = false,
    this.onBackPressed,
    this.navBar = true,
    this.pageTitle,
    this.pageTitleWidget,
    this.height = 70,
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
      appBar: widget.pageTitle != null || widget.pageTitleWidget != null
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).primaryColor,
              leading: widget.backBtn
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: widget.onBackPressed ??
                          () {
                            Navigator.pop(context);
                          },
                    )
                  : null,
              title: widget.pageTitleWidget ??
                  Center(child: Text(widget.pageTitle!)),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              widget.appBar ?? Container(),
              Expanded(child: widget.body),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          widget.navBar ? const BottomNavBar() : const SizedBox(),
    );
  }
}
