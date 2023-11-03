import 'package:point_of_sales/helpers/productdb.dart';

class Product {
  int id;
  String barcode;
  String name;
  int catId;
  int iconId;
  String description;
  String measurement;
  int stock;
  double price;
  double sellprice;

  Product({
    this.id = 0,
    required this.barcode,
    required this.name,
    required this.catId,
    required this.iconId,
    required this.description,
    required this.measurement,
    this.stock = 0,
    required this.price,
    required this.sellprice,
  });

  Map<String, dynamic> toMap() {
    return {
      ProductDBHelper.colBarcode: barcode,
      ProductDBHelper.colTitle: name,
      ProductDBHelper.colCatId: catId,
      ProductDBHelper.colIconId: iconId,
      ProductDBHelper.colDescription: description,
      ProductDBHelper.colMeasurement: measurement,
      ProductDBHelper.colStock: stock,
      ProductDBHelper.colPrice: price,
      ProductDBHelper.colSellprice: sellprice,
    };
  }

  List<dynamic> toList() {
    return [
      barcode,
      name,
      catId,
      iconId,
      description,
      measurement,
      stock,
      price,
      sellprice
    ];
  }
}
