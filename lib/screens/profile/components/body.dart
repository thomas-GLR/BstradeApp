import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bstrade/components/default_button.dart';
import 'package:bstrade/screens/manage_ad/manage_ad_screen.dart';
import 'package:bstrade/screens/home/home_screen.dart';
import 'verifie_utilisateur.dart';
import 'profile_pic.dart';

class Body extends StatelessWidget {
  final String documentId;

  Body(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong " + '$snapshot.error');
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
          //return Text(data['name']);
          return Scaffold(
              body: Center(
            //padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                SizedBox(height: 30),
                ProfilePic(utilisateurActuelle: data),
                Text(
                  data['name'],
                  style: new TextStyle(fontSize: 30),
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: 250,
                  child: DefaultButton(
                    text: "Modifier le profil",
                    press: () {
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyProfile(utilisateurActuelle: data)));
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifieUtilisateur(utilisateurActuelle: data)));
                    },
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  child: DefaultButton(
                    text: "Gérer mes annonces",
                    press: () {
                      Navigator.pushNamed(context, ManageAdScreen.routeName);
                    },
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  child: DefaultButton(
                    text: "Se déconnecter",
                    press: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        //Authenticate();
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      } catch (e) {
                        print(e.toString);
                        return null;
                      }
                    },
                  ),
                ),
                /*ButtonTheme(
                  minWidth: getProportionateScreenWidth(190),
                  height: getProportionateScreenHeight(56),
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: RaisedButton(
                    child: Text(
                      "Modifier le profile",
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyProfile()));
                    },
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(60)),
                ButtonTheme(
                  minWidth: getProportionateScreenWidth(190),
                  height: getProportionateScreenHeight(56),
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: RaisedButton(
                    child: Text(
                      'Gérer mes annonces',
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyProfile()));
                    },
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(60)),
                ButtonTheme(
                  minWidth: getProportionateScreenWidth(190),
                  height: getProportionateScreenHeight(56),
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: RaisedButton(
                    child: Text(
                      'Se déconnecter',
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyProfile()));
                    },
                  ),
                ),*/
              ],
            ),
          ));
        }

        return Text("loading");
      },
    );
  }
}
