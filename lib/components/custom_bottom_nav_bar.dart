import 'package:flutter/material.dart';
import 'package:bstrade/screens/home/home_screen.dart';
import 'package:bstrade/screens/profile/profile_screen.dart';
import 'package:bstrade/screens/publish/publish_screen.dart';
import 'package:bstrade/screens/favorites/favorites_screen.dart';
import 'package:bstrade/screens/wrapper.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:bstrade/models/person.dart';

import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  final MenuState selectedMenu;
  CustomBottomNavBar({this.selectedMenu});

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    final user = Provider.of<Person>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        /*
        border: Border(
          top: BorderSide(color: Colors.green),
        ),*/
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        /*borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),*/
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  color: MenuState.home == selectedMenu ? kCouleurPrincipale : inActiveIconColor,
                ),
                onPressed: () {
                  final newRouteName = HomeScreen.routeName;
                  bool isNewRouteSameAsCurrent = false;
                  Navigator.popUntil(context, (route) {
                    if (route.settings.name == newRouteName) {
                      isNewRouteSameAsCurrent = true;
                    }
                    return true;
                  });

                  if (!isNewRouteSameAsCurrent) {
                    //Navigator.pushNamed(context, newRouteName);
                    // Permet d'enlever la page derriere
                    Navigator.of(context).pushNamedAndRemoveUntil(newRouteName, (Route<dynamic> route) => false);
                  }
                },
              ),
              //Favorites
              IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: MenuState.favourite == selectedMenu ? kCouleurPrincipale : inActiveIconColor,
                ),
                onPressed: () {
                  final newRouteName = FavoritesScreen.routeName;
                  bool isNewRouteSameAsCurrent = false;
                  Navigator.popUntil(context, (route) {
                    if (route.settings.name == newRouteName) {
                      isNewRouteSameAsCurrent = true;
                    }
                    return true;
                  });

                  if (!isNewRouteSameAsCurrent) {
                    //Navigator.pushNamed(context, newRouteName);
                    Navigator.of(context).pushNamedAndRemoveUntil(newRouteName, (Route<dynamic> route) => false);
                  }
                },
              ),
              // Publish
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: MenuState.publish == selectedMenu ? kCouleurPrincipale : inActiveIconColor,
                ),
                onPressed: () {
                  final newRouteName = PublishScreen.routeName;
                  bool isNewRouteSameAsCurrent = false;
                  Navigator.popUntil(context, (route) {
                    if (route.settings.name == newRouteName) {
                      isNewRouteSameAsCurrent = true;
                    }
                    return true;
                  });

                  if (!isNewRouteSameAsCurrent) {
                    //Navigator.pushNamed(context, newRouteName);
                    Navigator.of(context).pushNamedAndRemoveUntil(newRouteName, (Route<dynamic> route) => false);
                  }
                },
              ),
              // Chat
              /*IconButton(
                icon: Icon(
                  Icons.chat_outlined,
                  color: MenuState.message == selectedMenu ? kCouleurPrincipale : inActiveIconColor,
                ),
                onPressed: () {},
              ),*/
              // Profile
              IconButton(
                icon: Icon(
                  Icons.person_outline,
                  color: MenuState.profile == selectedMenu ? kCouleurPrincipale : inActiveIconColor,
                ),
                onPressed: () {
                  final newRouteName = ProfileScreen.routeName;
                  bool isNewRouteSameAsCurrent = false;
                  Navigator.popUntil(context, (route) {
                    if (route.settings.name == newRouteName) {
                      isNewRouteSameAsCurrent = true;
                    }
                    return true;
                  });

                  if (!isNewRouteSameAsCurrent) {
                    //Navigator.pushNamed(context, newRouteName);
                    Navigator.of(context).pushNamedAndRemoveUntil(newRouteName, (Route<dynamic> route) => false);
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.login,
                  color: MenuState.login == selectedMenu ? kCouleurPrincipale : inActiveIconColor,
                ),
                onPressed: () {
                  if (user == null) {
                    Navigator.pushNamed(context, Wrapper.routeName);
                  } else {
                    try {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
                      _AffichePopUpDeconnexionReussie(context);
                      //Navigator.pushNamed(context, HomeScreen.routeName);
                    } catch (e) {
                      print(e.toString);
                      return null;
                    }
                  }
                },
              ),
            ],
          )),
    );
  }

  Future<void> _AffichePopUpDeconnexionReussie(dynamic context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Text('Vous avez bien été déconnecté !'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
