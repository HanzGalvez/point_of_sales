import 'package:flutter/material.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/invoice_model.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/models/invoice_line_model.dart';
import 'package:point_of_sales/models/product_model.dart';
import '../components/checkout_user_money_modal.dart';
import '../components/success_transaction_mode.dart';

class CheckOutScreen extends StatelessWidget {
  CheckOutScreen({super.key, required this.order, required this.productList});
  List<InvoiceLine> order;
  List<Product> productList;
  double totalPrice() {
    double total = 0;
    order.forEach((item) {
      total += item.subTotal();
    });
    return total;
  }

  int totalItem() {
    int total = 0;
    order.forEach((element) {
      total += element.qty;
    });
    return total;
  }

  var amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          "Check out",
          style: GoogleFonts.lato(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        toolbarHeight: 60,
        elevation: 0,
        iconTheme: const IconThemeData(
          size: 30,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Items:",
                        style: GoogleFonts.poppins(
                          fontSize: 23,
                          color: Colors.green[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 15,
                        ),
                        child: ListView.builder(
                          itemCount: order.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Product product = productList.singleWhere(
                                (temp) => temp.id == order[index].productId);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    color: const Color.fromRGBO(0, 0, 0, .7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${order[index].productPrice} * ${order[index].qty} ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    color: const Color.fromRGBO(0, 0, 0, .7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Total Price: ${totalPrice().toString()}",
                              style: GoogleFonts.poppins(
                                fontSize: 23,
                                color: Colors.green[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MyAlertAmountInput(
                          controller: amountController,
                          add: () {
                            if (amountController.text == "") {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text('Amount is required.'),
                                  );
                                },
                              );
                              return;
                            }
                            if (double.tryParse(amountController.text) ==
                                null) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                        'Invalid amount. Check your input.'),
                                  );
                                },
                              );
                              return;
                            }
                            double amount = double.parse(amountController.text);
                            if (totalPrice() > amount) {
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  content: Text(
                                    "Insufficient Amount.",
                                  ),
                                ),
                              );
                            } else {
                              final uuid = const Uuid().v4();
                              InvoiceDBHelper.insert(
                                Invoice(
                                  id: uuid,
                                  custumerPayAmount: amount,
                                  totalAmount: totalPrice(),
                                ),
                              );

                              for (var temp in order) {
                                temp.invoiceId = uuid;
                                InvoiceLineDBHelper.insert(temp);
                                ProductDBHelper.minus(
                                    id: temp.productId, qty: temp.qty);
                              }
                              double change = amount - totalPrice();
                              Navigator.pop(context);
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertSuccessModal(
                                  change: change,
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                  child: Text(
                    "Check Out",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
