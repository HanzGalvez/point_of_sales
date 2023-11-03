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

class TransactionDetailsScreen extends StatefulWidget {
  TransactionDetailsScreen({super.key, required this.invoice});
  Invoice invoice;

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  List<Product> _productlist = [];
  List<InvoiceLine> _invoiceLine = [];
  bool _isLoading = true;

  void _getList() async {
    final inv = await InvoiceLineDBHelper.getList();
    final product = await ProductDBHelper.getList();

    setState(() {
      inv.forEach((element) {
        if (element.invoiceId == widget.invoice.id) {
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
        backgroundColor: Colors.green[700],
        title: Text(
          "Transaction Details",
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
                              "Total Price: ${widget.invoice.totalAmount}",
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Total Product: ${_invoiceLine.length}",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Total Items: ${_totalItem()}",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Cash Tender: ${widget.invoice.custumerPayAmount}",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                              ),
                            )
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
                      itemCount: _invoiceLine.length,
                      itemBuilder: (context, index) {
                        Product product = _productlist.singleWhere(
                          (temp) => temp.id == _invoiceLine[index].productId,
                          orElse: () => Product(
                              barcode: "",
                              name: "",
                              catId: 0,
                              iconId: 0,
                              description: "",
                              measurement: "",
                              price: 0.00,
                              sellprice: 0.00),
                        );
                        return Card(
                          child: ListTile(
                            subtitle: Text(
                              "Total Price: ${_invoiceLine[index].subTotal()}",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(0, 0, 0, .7),
                              ),
                            ),
                            title: Text(
                              product.name != ""
                                  ? product.name
                                  : "<Product not found>",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[800],
                              ),
                            ),
                            trailing: Text(
                              "Qty: ${_invoiceLine[index].qty}",
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
