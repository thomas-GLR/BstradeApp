import 'package:flutter/widgets.dart';
import 'package:bstrade/screens/details/details_screen.dart';
import 'package:bstrade/screens/home/home_screen.dart';
import 'package:bstrade/screens/profile/profile_screen.dart';
import 'package:bstrade/screens/publish/publish_screen.dart';
import 'package:bstrade/screens/favorites/favorites_screen.dart';
import 'package:bstrade/screens/wrapper.dart';
import 'package:bstrade/screens/manage_ad/manage_ad_screen.dart';

// Toutes les routes sont répertoriés ici
final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  PublishScreen.routeName: (context) => PublishScreen(),
  FavoritesScreen.routeName: (context) => FavoritesScreen(),
  ManageAdScreen.routeName: (context) => ManageAdScreen(),
  Wrapper.routeName: (context) => Wrapper(),
};
