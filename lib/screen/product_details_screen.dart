import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/models/invoice_line_model.dart';
import 'package:point_of_sales/models/product_model.dart';

import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({super.key, required this.product});
  Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var _category = [];
  List<InvoiceLine> _productOrderList = [];
  bool _isLoading = true;

  void _getList() async {
    final data = await CategoryDBHelper.getSingleList(widget.product.catId);
    final list =
        await InvoiceLineDBHelper.getListofSingleProduct(widget.product.id);
    setState(() {
      _productOrderList = list;
      _category = data;
      _isLoading = false;
    });
  }

  int _totalSold() {
    int total = 0;
    _productOrderList.forEach((element) {
      total += element.qty;
    });
    return total;
  }

  double _totalSales() {
    double total = 0;
    _productOrderList.forEach((element) {
      total += element.subTotal();
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
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          widget.product.name,
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
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${widget.product.name}",
                                style: GoogleFonts.poppins(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[700],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Descriptions: ${widget.product.description}",
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                "Barcode: ${widget.product.barcode}",
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                "Category: ${_category.isEmpty ? '<not found>' : _category.last[CategoryDBHelper.colTitle]}",
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                "Price: ${widget.product.price}",
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                "Stock: ${widget.product.stock}",
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  color: widget.product.stock < 6
                                      ? Colors.red
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Product summary:",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(0, 0, 0, .7),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Card(
                        color: Colors.green[700],
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total sold items: ${_totalSold()}",
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Total Sales: ${_totalSales()}",
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
      drawer: MyDrawer(),
      floatingActionButton: MyFloatingActionOrder(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(active: -1),
    );
  }
}
