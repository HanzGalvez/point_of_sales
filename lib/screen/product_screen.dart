import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/screen/product_details_screen.dart';
import '../components/add_product_modal_component.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/product_card_component.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var _productlist = [];
  List<Map<String, dynamic>> _popular = [];
  bool _isLoading = true;
  int undoAdd = 0;

  void _getProductList() async {
    final data = await ProductDBHelper.getList();
    final result = await InvoiceLineDBHelper.getPopularProduct();
    setState(() {
      _productlist = data;
      _popular = result;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          "Product",
          style: GoogleFonts.lato(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AddProductModel(
                    add: (product) async {
                      undoAdd = await ProductDBHelper.insert(product);
                      _getProductList();
                    },
                    undo: () {
                      ProductDBHelper.delete(undoAdd);
                      _getProductList();
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
                    size: 24,
                  ),
                  Text(
                    "Add",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
          : _productlist.isEmpty
              ? Center(
                  child: Text(
                    'Product is empty',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _productlist.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        onUpdate: () {
                          _getProductList();
                        },
                        onDismissed: () {
                          _getProductList();
                        },
                        product: _productlist[index],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ProductDetailsScreen(
                                  product: _productlist[index],
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
      drawer: MyDrawer(),
      floatingActionButton: MyFloatingActionOrder(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(active: -1),
    );
  }
}
