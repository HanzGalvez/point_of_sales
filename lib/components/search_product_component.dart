import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/most_latest_product_card_component.dart';
import 'package:point_of_sales/screen/inventory_product_details_screen.dart';
import 'package:point_of_sales/screen/product_details_screen.dart';

import '../models/product_model.dart';

class SearchList extends StatelessWidget {
  SearchList({super.key, required this.searchList});
  List<Product> searchList;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "Search Product",
          style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(0, 0, 0, .7)),
        ),
        SizedBox(
          height: 2,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InventoryDetailsScreen(
                          product: searchList[index],
                        ),
                      ),
                    );
                  },
                  child: LatestProductCard(product: searchList[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
