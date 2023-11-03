import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/text_field_component.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/product_model.dart';

class MyAlertAddStock extends StatelessWidget {
  MyAlertAddStock({
    Key? key,
    required this.onUpdate,
    required this.productId,
    required this.stock,
  }) : super(key: key);
  int productId;
  int stock;
  var controller = TextEditingController();
  final Function onUpdate;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Text(
        "Add Stock",
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
                label: "Stock",
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
                    if (int.tryParse(controller.text) == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Invalid input.'),
                          );
                        },
                      );
                      return;
                    }
                    int present = stock + int.parse(controller.text);
                    if (present < 0) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Over decrease.'),
                          );
                        },
                      );
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                              ),
                              onPressed: () {
                                ProductDBHelper.addStock(
                                  productId: productId,
                                  value: (stock + int.parse(controller.text)),
                                );
                                onUpdate();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Yes',
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                          content: Text(present < stock
                              ? 'Are you sure you want to decrease ${int.parse(controller.text) * (-1)}?'
                              : "Are you sure you want add ${controller.text} item/s?"),
                        );
                      },
                    );
                  },
                  child: Text(
                    "Add",
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
