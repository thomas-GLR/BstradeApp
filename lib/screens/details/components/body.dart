import 'package:flutter/material.dart';

import 'image_produit.dart';

class Body extends StatelessWidget {
  final Map<String, dynamic> product;

  Body({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20, color: Colors.white));
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20, color: Colors.white));
    return ListView(
      children: [
        SizedBox(height: 10),
        ImageProduit(product: product),
        //ProductImages(product: product),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 0.0),
          child: Text(
            product['title'],
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "${product['price']}€",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 25),
        product['priceCVE'] != ''
            ? Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Icon(
                        Icons.volunteer_activism,
                        color: Colors.green[300],
                        size: 30.0,
                      ), // Icon
                    ), // Container
                  ), // Align
                  Spacer(),
                  Text(
                    "Le vendeur s’engage \nà verser ${product['priceCVE']} € au CVE",
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      padding: EdgeInsets.only(right: 30.0),
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.black,
                        size: 30.0,
                      ), // Icon
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Qu\'est ce que le CVE'),
                          content: const Text('Le Conseil de Vie Étudiante est composé d\'élèves et formateurs qui organisent diverses animations et évènements afin d\'apporter un peu de divertissement dans la vie étudiante. En reversant une part de votre recette au CVE, vous encourager et contribuez à la vie du campus et offrez la possibilité de concrétiser divers projets.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                    ), // IconButton
                  ), // Align
                ],
              )
            : Container(),
        const Divider(
          color: Colors.grey,
          height: 80,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                "Critères",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        product['state'] != ''
            ? Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  ),
                  Icon(
                    Icons.thumb_up_alt_outlined,
                    color: Colors.grey,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Text(
                      product['state'],
                    ),
                  ),
                ],
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            ),
            Icon(
              Icons.format_list_bulleted,
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Text(
                product['category'],
              ),
            ),
          ],
        ),
        const Divider(
          color: Colors.grey,
          height: 80,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        product['description'] != ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: Text(
                      product['description'],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 80,
                    thickness: 2,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              )
            : Container(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    "Vendeur",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Text(
                product['nomVendeur'],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              height: 80,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    "Contact",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Text(
                product['contactUtilisateur'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        )
        /*const Divider(
          color: Colors.grey,
          height: 80,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
          child: ButtonTheme(
            minWidth: 190,
            height: 56,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: RaisedButton(
              onPressed: () {}, // onPressed
              child: Text(
                'Contacter le vendeur',
                style: TextStyle(fontSize: 20, color: Colors.white), // TextStyle
              ), // Text
              color: Colors.green,
            ), // RaisedButton
          ),
        ),
        SizedBox(
          height: 40,
        ),*/
        /*TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: product,
                //pressOnSeeMore: () {},
              ),
              TopRoundedContainer(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * 0.15,
                    right: SizeConfig.screenWidth * 0.15,
                    bottom: getProportionateScreenWidth(40),
                    top: getProportionateScreenWidth(15),
                  ),
                  child: DefaultButton(
                    text: "Add To Cart",
                    press: () {},
                  ),
                ),
              ),
            ],
          ),
        ),*/
      ],
    );
  }
}
