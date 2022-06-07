import 'package:flutter/material.dart';

import 'package:bstrade/components/custom_bottom_nav_bar.dart';
import 'package:bstrade/enums.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BS\'Trade',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ), // AppBar
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
