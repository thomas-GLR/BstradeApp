import 'package:flutter/material.dart';

class Product {
  int id;
  String title, description, category, state;
  List<String> images;
  List<Color> colors;
  double rating, price;
  String productPrice, priceCVE;
  bool isFavourite, isPopular;

  Product({this.id, this.images, this.colors, this.rating = 0.0, this.isFavourite = false, this.isPopular = false, this.title, this.productPrice, this.price, this.description, this.category, this.state, this.priceCVE});
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: [
      "assets/images/empty_image.png",
      "assets/images/empty_image.png",
      "assets/images/empty_image.png",
      "assets/images/empty_image.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Wireless Controller for PS4™",
    price: 64.99,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
    category: "Informatique",
    state: "Neuf",
  ),
  Product(
    id: 2,
    images: [
      "assets/images/empty image.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Nike Sport White - Man Pant",
    price: 50.5,
    description: description,
    rating: 4.1,
    isPopular: true,
    category: "Informatique",
    state: "Bon état",
  ),
  Product(
    id: 3,
    images: [
      "assets/images/glap.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Gloves XC Omega - Polygon",
    price: 36.55,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
    category: "Livres",
    state: "Bon état",
  ),
  Product(
    id: 4,
    images: [
      "assets/images/wireless headset.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Logitech Head",
    price: 20.20,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: false,
    category: "Livres",
    state: "Très bon état",
  ),
  Product(
    id: 5,
    images: [
      "assets/images/wireless headset.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Logitech Head",
    price: 20.20,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: false,
    category: "Vetements",
    state: "Satisfaisant",
  ),
  Product(
    id: 6,
    images: [
      "assets/images/wireless headset.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Logitech Head",
    price: 20.20,
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: false,
    category: "Vetements",
    state: "Neuf",
  ),
];

const String description = "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
