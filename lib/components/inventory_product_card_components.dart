import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/productdb.dart';

import '../models/product_model.dart';
import '../screen/product_details_screen.dart';
import 'add_stock_modal_component.dart';
import 'edit_product_modal_component.dart';

class InventoryProductCard extends StatelessWidget {
  InventoryProductCard({
    Key? key,
    required this.product,
    required this.onTap,
    required this.onUpdate,
  }) : super(key: key);

  final Product product;
  Function onTap;
  Function onUpdate;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        tileColor: Color.fromRGBO(213, 236, 223, 100),
        onTap: () {
          onTap();
        },
        title: Text(
          product.name,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.green[800],
          ),
        ),
        subtitle: Text(
          "Stock: ${product.stock.toString()}",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(0, 0, 0, .7),
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return MyAlertAddStock(
                  stock: product.stock,
                  productId: product.id,
                  onUpdate: () {
                    onUpdate();
                  },
                );
              },
            );
          },
          icon: Icon(
            Icons.edit_note_outlined,
            color: Color.fromRGBO(56, 142, 60, 1),
          ),
        ),
      ),
    );
  }
}
