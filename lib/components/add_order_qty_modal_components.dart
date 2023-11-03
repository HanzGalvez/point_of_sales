import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/text_field_component.dart';

import '../models/product_model.dart';

class MyAlertQtyModal extends StatelessWidget {
  MyAlertQtyModal({
    Key? key,
    required this.tempProduct,
    required this.controller,
    required this.add,
    this.qty = 0,
    this.btnText = 'Add',
  }) : super(key: key);

  final Product tempProduct;
  final TextEditingController controller;
  final Function add;
  int qty;
  String btnText;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    controller.text = '1';
    return AlertDialog(
      title: Text(
        tempProduct.name,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      content: Container(
        width: width * .75,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldComponents(
                label: "Quantity",
                controller: controller,
                keyboardType: TextInputType.number,
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700]),
                  onPressed: () {
                    if (qty == 0) {
                      add();
                      return;
                    }
                    int result = add();
                    if (result == 0) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: Text(
                                "The item have only ${tempProduct.stock} stock  and ${tempProduct.stock - qty} available."),
                          );
                        },
                      );
                    } else if (result == 2) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: Text("Quantity is required."),
                          );
                        },
                      );
                    } else if (result == 3) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: Text("Invalid quantity"),
                          );
                        },
                      );
                    } else if (result == 4) {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content:
                                Text("Quantity cannot be negative or zero"),
                          );
                        },
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    btnText,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
