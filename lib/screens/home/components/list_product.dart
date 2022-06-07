import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bstrade/components/product_card.dart';

class ListProduct extends StatefulWidget {
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  // Order by date de la plus récente à la moins récente !
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance.collection('products').orderBy('heurePublication', descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('Impossible de charger les produits ' + snapshot.error.toString());
            return Text('Impossible de charger les produits');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              strokeWidth: 10,
            );
          }

          return ListView(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              String idProduitActuelle = document.id;
              Map<String, dynamic> informationsProduit = document.data() as Map<String, dynamic>;
              return ProductCard(produitActuelle: informationsProduit, idProduit: idProduitActuelle);
              /*return Container(
                        height: 200,
                        child: Text(
                          'test',
                          style: TextStyle(fontSize: 25),
                        ));*/
            }).toList(),
          );

// Tentative de code pour avoir 2 colonnes de produit au lieu d'une (à revoir)
/*
        return GridView.count(shrinkWrap: true, primary: false, padding: const EdgeInsets.all(20), crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 2, children: [
          SizedBox(
            width: 180,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                String idCurrentProduct = document.id;
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return ProductCard(produitActuelle: data, idProduit: idCurrentProduct);
              }).toList(),
            ),
          ),
          SizedBox(
            width: 180,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                String idCurrentProduct = document.id;
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return ProductCard(produitActuelle: data, idProduit: idCurrentProduct);
              }).toList(),
            ),
          )
        ]);
*/
        },
      ),
    );
  }
}
