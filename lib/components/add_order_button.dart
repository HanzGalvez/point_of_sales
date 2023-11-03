import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_order_barcode_modal.dart';

class AddOrderBUtton extends StatelessWidget {
  AddOrderBUtton({super.key, required this.controller, required this.add});
  TextEditingController controller;
  Function add;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialogBarcode(
              controller: controller,
              add: () {
                add();
              },
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
        child: Row(
          children: [
            const Icon(
              Icons.add,
              size: 20,
            ),
            Text(
              "Add",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
