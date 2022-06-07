import 'package:flutter/material.dart';
import 'package:bstrade/components/custom_bottom_nav_bar.dart';
import 'package:bstrade/enums.dart';

import 'components/body.dart';

class ManageAdScreen extends StatelessWidget {
  static String routeName = "/manage_ad";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes annonces"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
