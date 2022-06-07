import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bstrade/models/person.dart';
import 'package:bstrade/constants.dart';

class CustomAppBar extends StatelessWidget {
  final Map<String, dynamic> product;
  final String idProduct;
  //final Product product;
  const CustomAppBar({
    Key key,
    this.product,
    this.idProduct,
  }) : super(key: key);
  //final double rating;

  //CustomAppBar({required this.rating});

  @override
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    Future<void> _AffichePopUpAnnoncePublie(String texteAfficheDansPopup) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            //title: const Text('AlertDialog Title'),
            content: SingleChildScrollView(
              child: Text(texteAfficheDansPopup),
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

    final user = Provider.of<Person>(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  primary: kCouleurPrincipale,
                  //backgroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                ),
                onPressed: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  "assets/icons/arrow_back.svg",
                  height: 15,
                ),
              ),
            ),
            Spacer(),
            // Un utilisateur non connecté ne peut pas utiliser les favoris, je désactive donc la fonctionnalité d'ajout de favoris !
            user != null
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    // si user pas connecté alors return container();
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('listeDeFavoris').doc(idProduct).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Une erreur est survenue lors de la récupération de la wishlist");
                          }

                          if (snapshot.hasData && !snapshot.data.exists) {
                            //return Text("Document does not exist");
                            return IconButton(
                                icon: Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                  size: 30.0,
                                ), // Icon
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .collection('listeDeFavoris')
                                      .doc(idProduct)
                                      .set({
                                        'idUtilisateur': user.uid,
                                        'idProduit': idProduct,
                                      })
                                      .then((value) => print("Favoris ajouté à la liste de favoris !"))
                                      .catchError((error) => print("Erreur dans l'ajout du favoris: $error"));

                                  //_AffichePopUpAnnoncePublie("Le produit a été ajouté à votre liste de favoris !");
                                });
                          }
                          if (snapshot.hasData) {
                            return IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.green,
                                  size: 30.0,
                                ), // Icon
                                onPressed: () {
                                  FirebaseFirestore.instance.collection('users').doc(user.uid).collection('listeDeFavoris').doc(idProduct).delete().then((value) => print("Favoris supprimé de la liste de favoris !")).catchError((error) => print("Erreur dans la suppression du favoris: $error"));
                                  //_AffichePopUpAnnoncePublie("Le produit a été supprimé de votre liste de favoris !");
                                });
                          }

                          return Container();
                        }),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
