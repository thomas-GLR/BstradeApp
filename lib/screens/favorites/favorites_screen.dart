import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:bstrade/components/custom_bottom_nav_bar.dart';
import 'package:bstrade/enums.dart';
import 'package:bstrade/screens/authenticate/authenticate.dart';
import 'package:bstrade/screens/home/home_screen.dart';
import 'package:bstrade/models/person.dart';

import 'components/body.dart';

class FavoritesScreen extends StatelessWidget {
  static String routeName = "/favorites";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Person>(context);
    // Je n'autorise pas l'accès à cette page si l'utilisateur n'est pas connecté, je le redirige donc vers la page de connexion si pas connecté !
    if (user == null) {
      return Authenticate();
    } else {
      return Scaffold(
        appBar: AppBar(
            title: Text("Favoris"),
            primary: true,
            centerTitle: true,
            backgroundColor: Colors.green,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false),
              //onPressed: () => Navigator.pop(context),
            )),
        body: Body(),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.favourite),
      );
    }
  }
}
