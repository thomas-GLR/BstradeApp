import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:bstrade/models/person.dart';
import 'manage_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Person>(context);
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance.collection('products').where('idUtilisateur', isEqualTo: user.uid).snapshots();
    /*FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((DocumentSnapshot documentSnapshotUtilisateur) {
      documentSnapshotUtilisateur.get('adId').forEach((idProduitUtilisateur) {
        if (idProduitUtilisateur == 'gCgmnpuQHHseRFjZiM9v') {
          test = true;
        }
      });
    });
    print(test);*/
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            strokeWidth: 10,
          );
        }

        //FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((DocumentSnapshot documentSnapshotUtilisateur) {
        //documentSnapshotUtilisateur.get('adId').forEach((idProduitUtilisateur) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
              child: Column(children: [
                SizedBox(
                  width: 350,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      String idCurrentProduct = document.id;
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return ManageCard(produit: data, idProduit: idCurrentProduct);
                    }).toList(),
                  ),
                ),
              ]),
            ),
          ),
        );
        //});
      },
    );
  }
}
/*
class Body extends StatelessWidget {
  final List listeProduitUtilisateurCourant;

  Body({this.listeProduitUtilisateurCourant});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Person>(context);
    Map<String, dynamic> produit;
    /*
    FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((DocumentSnapshot documentSnapshotUtilisateur) {
      documentSnapshotUtilisateur.get('adId').forEach((idProduitUtilisateur) {
        FirebaseFirestore.instance.collection('products').doc(idProduitUtilisateur).get().then((DocumentSnapshot documentSnapshotProduit) {
          print(documentSnapshotProduit.data());
          produit = documentSnapshotProduit.data();
          return ManageCard(produit: documentSnapshotProduit.data(), userId: user.uid);
        });
      });
    });*/
    /*
    print(produit['title']);
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
          child: Column(
            children: [
              Text(""),
            ],
          ), // Column
        ), // Padding
      ), //SingleChildScrollView
    );*/
  }
}*/
