import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/product_model.dart';

class PopularProductCard extends StatelessWidget {
  PopularProductCard(
      {Key? key,
      required this.product,
      required this.totalsales,
      required this.totalsold})
      : super(key: key);

  final Product product;

  double totalsales;
  int totalsold;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${product.name}",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.green[700],
              ),
            ),
            Text(
              "Price: ${product.name == "<Product Not Found>" ? '<Price not found>' : product.price}",
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
            Text(
              "Total sold: $totalsold",
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
            Text(
              "Total Sales: $totalsales",
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
