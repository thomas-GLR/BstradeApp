import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:bstrade/screens/home/home_screen.dart';
import 'package:bstrade/screens/authenticate/authenticate.dart';
import 'package:bstrade/models/person.dart';

class Wrapper extends StatelessWidget {
  static String routeName = "/wrapper";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Person>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}
