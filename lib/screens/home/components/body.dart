import 'package:flutter/material.dart';

import 'package:bstrade/screens/home/components/list_product.dart';
import 'home_header.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            HomeHeader(), // Permet d'intégrer la barre de recherche (inutile pour le moment)
            SizedBox(height: 20),
            ListProduct(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
