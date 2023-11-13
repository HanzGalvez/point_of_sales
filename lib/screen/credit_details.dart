import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/models/invoice_line_model.dart';
import 'package:point_of_sales/models/invoice_model.dart';
import 'package:point_of_sales/models/product_model.dart';

import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../helpers/productdb.dart';

class CreditDetailsScreen extends StatefulWidget {
  CreditDetailsScreen({
    super.key,
  });

  @override
  State<CreditDetailsScreen> createState() => _CreditDetailsScreenState();
}

class _CreditDetailsScreenState extends State<CreditDetailsScreen> {
  List<Product> _productlist = [];
  List<InvoiceLine> _invoiceLine = [];
  bool _isLoading = true;

  void _getList() async {
    final inv = await InvoiceLineDBHelper.getList();
    final product = await ProductDBHelper.getList();

    setState(() {
      inv.forEach((element) {
        if (element.invoiceId == 1) {
          _invoiceLine.add(element);
        }
      });
      _productlist = product;
      _isLoading = false;
    });
  }

  int _totalItem() {
    int total = 0;
    _invoiceLine.forEach((element) {
      total += element.qty;
    });
    return total;
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(45, 161, 95, 100),
                Colors.green
              ], // Adjust the colors as needed
            ),
          ),
        ),
        title: Text(
          "Credit Details",
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green[700],
            ))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Remaining Credit: P100.00",
                              style: GoogleFonts.poppins(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Total Price: P1000.00",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Total Product: 2",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Total Items: 10",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Text(
                              "Listed By: Dick Lomibao",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Partials",
                              style: GoogleFonts.poppins(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              title: Text("Paid: P900.00"),
                              subtitle: Text("Date: 11-13-2023"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Order list:",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, .7),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        // Product product = _productlist.singleWhere(
                        //   (temp) => temp.id == _invoiceLine[index].productId,
                        //   orElse: () => Product(
                        //       barcode: "",
                        //       name: "",
                        //       catId: 0,
                        //       description: "",
                        //       price: 0.00),
                        // );
                        return Card(
                          child: ListTile(
                            subtitle: Text(
                              "Total Price: 500.00",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, .7),
                              ),
                            ),
                            title: Text(
                              "Milo" != "" ? "Milo" : "<Product not found>",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[800],
                              ),
                            ),
                            trailing: Text(
                              "Qty: 5",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(0, 0, 0, .7),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      drawer: MyDrawer(),
      floatingActionButton: MyFloatingActionOrder(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(active: 1),
    );
  }
}
