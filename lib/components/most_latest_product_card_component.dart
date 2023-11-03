import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';

class LatestProductCard extends StatelessWidget {
  const LatestProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
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
              "Description: ${product.description}",
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
            Text(
              "Stock: ${product.stock}",
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
            Text(
              "Price: ${product.price}",
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
