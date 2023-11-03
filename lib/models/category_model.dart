import 'package:flutter/material.dart';
import 'package:point_of_sales/helpers/categorydb.dart';

class Category {
  int id;
  String title;
  String description;
  int icon;

  Category({
    this.id = 0,
    required this.title,
    required this.description,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      CategoryDBHelper.colTitle: title,
      CategoryDBHelper.colDescription: description,
      CategoryDBHelper.colIcon: icon
    };
  }

  List<dynamic> toList() {
    return [title, description, icon];
  }
}

List<Icon> icons = [
  Icon(Icons.shopify),
  Icon(Icons.local_drink),
  Icon(Icons.local_dining),
  Icon(Icons.fastfood),
  Icon(Icons.local_florist),
  Icon(Icons.eco),
  Icon(Icons.shopping_cart),
  Icon(Icons.local_mall),
  Icon(Icons.local_pizza),
  Icon(Icons.anchor),
  Icon(Icons.fastfood),
  Icon(Icons.cake),
  Icon(Icons.accessibility),
  Icon(Icons.cleaning_services),
  Icon(Icons.healing),
  Icon(Icons.home),
  Icon(Icons.child_friendly),
  Icon(Icons.pets),
  Icon(Icons.ac_unit),
  Icon(Icons.restaurant),
  Icon(Icons.restaurant_menu)
];
