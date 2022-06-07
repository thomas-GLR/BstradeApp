import 'package:flutter/material.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments agrs = ModalRoute.of(context).settings.arguments as ProductDetailsArguments;
    return Scaffold(
      //backgroundColor: Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(product: agrs.product, idProduct: agrs.idProduct),
      ),
      body: Body(product: agrs.product),
    );
  }
}

class ProductDetailsArguments {
  //final Product product;
  final Map<String, dynamic> product;
  final String idProduct;

  ProductDetailsArguments({
    this.product,
    this.idProduct,
  });
}
