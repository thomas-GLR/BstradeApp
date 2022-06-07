import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bstrade/screens/details/details_screen.dart';
import 'package:bstrade/models/person.dart';
import 'package:bstrade/services/storage_service.dart';
import 'package:bstrade/constants.dart';

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    Key key,
    this.produitEnFavoris,
    this.idProduit,
  }) : super(key: key);

  //final Map<String, dynamic> produitActuelle;
  final DocumentSnapshot produitEnFavoris;
  final String idProduit;

  @override
  Widget build(BuildContext context) {
    // je converti les données du produit en Map<String, dynamic> pour les passer en paramètre de ma page détail
    //Map<String, dynamic> donneeProduitActuelle = produitEnFavoris.data() as Map<String, dynamic>;
    final user = Provider.of<Person>(context);

    CollectionReference collectionDeProduit = FirebaseFirestore.instance.collection('products');

    return FutureBuilder<DocumentSnapshot>(
      future: collectionDeProduit.doc(idProduit).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> donneeProduitActuelle = snapshot.data.data() as Map<String, dynamic>;
          //return Text("Full Name: ${data['full_name']} ${data['last_name']}");
          return Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: FutureBuilder(
                          future: Storage().recupererImageURL(donneeProduitActuelle['cheminImageCloudStorage'].toString()),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(snapshot.data),
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset('assets/images/empty_image.png'),
                            );
                          }),
                    ),
                    Padding(padding: EdgeInsets.only(right: 20)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 170,
                          child: Text(
                            donneeProduitActuelle['title'],
                            style: TextStyle(color: Colors.black),
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${donneeProduitActuelle['price']}€",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kCouleurPrincipale,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    //Bouton pour voir le favoris
                    ButtonTheme(
                      minWidth: 250,
                      height: 60,
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            DetailsScreen.routeName,
                            arguments: ProductDetailsArguments(product: donneeProduitActuelle, idProduct: idProduit),
                          );
                        }, // onPressed
                        child: Text(
                          'Voir le favoris',
                          style: TextStyle(fontSize: 20, color: Colors.black), // TextStyle
                        ), // Text
                        color: Colors.white,
                      ), // RaisedButton
                    ),
                    SizedBox(width: 20),
                    // Bouton pour supprimer un favoris
                    ButtonTheme(
                      minWidth: 60,
                      height: 60,
                      padding: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: RaisedButton(
                        onPressed: () {
                          // Mon favoris est enregistré dans une sous collection de la collection utilisateur n'ayant pas réussi a récupérer les id produits dans un tableau id dans l'utilisateur
                          FirebaseFirestore.instance.collection('users').doc(user.uid).collection('listeDeFavoris').doc(idProduit).delete().then((value) => print("Favoris supprimé de la liste de favoris !")).catchError((error) => print("Erreur dans la suppression du favoris: $error"));
                        }, // onPressed
                        child: Icon(
                          Icons.delete_outline,
                        ),
                        color: Colors.white,
                      ), // RaisedButton
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
