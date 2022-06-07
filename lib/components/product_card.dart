import 'package:flutter/material.dart';

import 'package:bstrade/screens/details/details_screen.dart';
import 'package:bstrade/services/storage_service.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.produitActuelle,
    this.idProduit,
  }) : super(key: key);

  final Map<String, dynamic> produitActuelle;
  final String idProduit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        DetailsScreen.routeName,
        arguments: ProductDetailsArguments(product: produitActuelle, idProduct: idProduit),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 30),
        child: SizedBox(
          width: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: FutureBuilder(
                        future: Storage().recupererImageURL(produitActuelle['cheminImageCloudStorage'].toString()),
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
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 180,
                      child: Text(
                        produitActuelle['title'],
                        style: TextStyle(color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${produitActuelle['price']}€",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    )
                  ]),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
// Ancien affichage en gros plan (1 ou 2 produit max)
/*
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.02, //1.02
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[500].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Hero(
                      tag: idProduit, //product.id.toString(),
                      child: FutureBuilder(
                          future: Storage().recupererImageURL(produitActuelle['cheminImageCloudStorage'].toString()),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(snapshot.data),
                              );
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            return Container(
                              child: Image.asset('assets/images/empty_image.png'),
                            );
                          }),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  produitActuelle['title'],
                  style: TextStyle(color: Colors.black),
                  maxLines: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${produitActuelle['price']}€",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              ],
            ),*/
        ),
      ),
    );
  }
}
