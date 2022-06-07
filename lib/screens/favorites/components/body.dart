import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bstrade/models/person.dart';
import 'package:provider/provider.dart';

import 'favorite_card.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Person>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('listeDeFavoris').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> produitDeListeDeFavorisSnapshot) {
        if (produitDeListeDeFavorisSnapshot.hasError) {
          return Text('Something went wrong');
        }

        if (produitDeListeDeFavorisSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            strokeWidth: 10,
          );
        }

        return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(children: [
              Column(children: [
                SizedBox(height: 20),
                SizedBox(
                  width: 350,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: produitDeListeDeFavorisSnapshot.data.docs.map((DocumentSnapshot produitFavorisUtilisateur) {
                      //return Container();
                      return FavoriteCard(produitEnFavoris: produitFavorisUtilisateur, idProduit: produitFavorisUtilisateur.id);
                      /*FirebaseFirestore.instance.collection('products').doc(produitFavorisUtilisateur.id).get().then((DocumentSnapshot donneeProduitActuelle) {
                        return FavoriteCard(produitEnFavoris: donneeProduitActuelle, idProduit: produitFavorisUtilisateur.id);
                      });*/
                    }).toList(),
                  ),
                )
              ])
            ]));
      },
    );
  }
}
