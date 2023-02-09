import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/layout/layout.dart';

class ContactsScreen extends StatelessWidget {
  static const String route = '/contacts';

  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Layout(body: Text('Contacts Screen'));
  }
}
