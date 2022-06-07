import 'package:flutter/material.dart';
import 'package:bstrade/components/custom_bottom_nav_bar.dart';
import 'package:bstrade/enums.dart';
import 'package:provider/provider.dart';
import 'package:bstrade/models/person.dart';
import 'package:bstrade/screens/authenticate/authenticate.dart';
import 'package:bstrade/screens/home/home_screen.dart';

import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Person>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Scaffold(
        appBar: AppBar(
            title: Text("Profile"),
            centerTitle: true,
            backgroundColor: Colors.green,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false),
              //onPressed: () => Navigator.pop(context),
            )),
        body: Body(user.uid),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
      );
    }
  }
}
