import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:bstrade/services/storage_service.dart';
import 'package:bstrade/services/database.dart';
import 'package:bstrade/models/person.dart';

import '../../../constants.dart';

class ManageCard extends StatelessWidget {
  ManageCard({
    Key key,
    this.width = 240,
    this.aspectRetio = 1.02,
    this.produit,
    this.idProduit,
  }) : super(key: key);

  final double width, aspectRetio;
  final Map<String, dynamic> produit;
  final String idProduit;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Person>(context);
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Container(
        //padding: EdgeInsets.all(20),
        //decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        //width: width,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  child: FutureBuilder(
                      future: Storage().recupererImageURL(produit['cheminImageCloudStorage'].toString()),
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
                        return Container(
                          width: 100,
                          height: 100,
                          child: Image.asset('assets/images/empty_image.png'),
                        );
                      }),
                ),
                //Image.asset('assets/images/empty_image.png', width: 100, height: 100),
                Padding(padding: EdgeInsets.only(right: 20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 170,
                      child: Text(
                        produit['title'],
                        style: TextStyle(color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${produit['price']}€",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kCouleurPrincipale,
                      ),
                    ),
                  ],
                ), // Column
              ],
            ),
            SizedBox(height: 10),
            // bouton supprimer
            ButtonTheme(
              minWidth: 350,
              height: 56,
              padding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child: RaisedButton(
                onPressed: () {
                  return showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          //title: const Text('AlertDialog Title'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const <Widget>[
                                Text('Souhaitez vous vraiment supprimer votre publication ?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Annuler'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Supprimer'),
                              onPressed: () {
                                FirebaseFirestore.instance.collection('products').doc(idProduit).delete().then((value) => print("Produit supprimé")).catchError((error) => print("Failed to delete user: $error"));
                                // je supprime l'annonce de la liste de favoris de tous les utilisateurs
                                DatabaseService(uid: user.uid).supprimerAncienneAnnonceListeFavoris(idProduit);
                                Storage().supprimerImage(produit['cheminImageCloudStorage'].toString());
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                }, // onPressed
                child: Text(
                  'Supprimer',
                  style: TextStyle(fontSize: 20, color: Colors.black), // TextStyle
                ), // Text
                color: Colors.white,
              ), // RaisedButton
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
