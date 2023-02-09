import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mochi/main.dart';

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
  @override
  void initState() {
    if (widget.needsAuth) {
      // TODO: Redirect user if not authenticated
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: widget.navBar ? const BottomNavBar() : Container(),
    );
  }
}
