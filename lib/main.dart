import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:bstrade/routes.dart';
import 'package:bstrade/screens/home/home_screen.dart';
import 'package:bstrade/models/person.dart';
import 'package:bstrade/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCp8TjXCsHLL5JKJ4oeoldy8TtNDOtqZus",
      appId: "com.treecorp.bstrade",
      messagingSenderId: "630722860534",
      projectId: "treecorp-bstrade-project-app",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Person>.value(
      initialData: null,
      value: AuthService().user, // create an instance of AuthService and accessing user stream on it
      child: MaterialApp(
        // Tous les widgets descendants peuvent accéder aux données fournies par le flux (StreamProvider)
        // ce qui rend nécessaire l'utilisation du StreamProvider sans quoi on obtient des erreurs !
        title: 'Application BSTrade',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        // L'application nous redirige sur la page d'accueil lors de son lancement
        // Pas de page redirection sur la page login lors du lancement afin d'éviter la frustration de l'utilisateur
        // (toujours devoir se login avant de voir les produits en ligne peut etre lassant !)
        home: HomeScreen(),
        initialRoute: HomeScreen.routeName,
        routes: routes,
      ), // materialApp
    ); // StreamProvider.value
  }
}
