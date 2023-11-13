import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import '../components/inventory_product_card_components.dart';
import '../helpers/productdb.dart';
import 'inventory_product_details_screen.dart';

class InventoryScreen extends StatefulWidget {
  InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    var p = _productlist.where((element) => element.barcode == barcodeScanRes);
    if (p.isNotEmpty) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return InventoryDetailsScreen(product: p.first);
        },
      ));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Invalid Barcode"),
        ),
      );
    }
  }

  var _productlist = [];
  bool _isLoading = true;

  void _getProductList() async {
    final data = await ProductDBHelper.getList();
    setState(() {
      _productlist = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _getProductList();
    super.initState();
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
        actions: [
          GestureDetector(
            onTap: () {
              scanBarcodeNormal();
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.document_scanner_outlined,
                size: 30,
              ),
            ),
          )
        ],
        title: Text(
          "Inventory",
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
                      return InventoryProductCard(
                        onUpdate: () {
                          _getProductList();
                        },
                        product: _productlist[index],
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return InventoryDetailsScreen(
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
      bottomNavigationBar: BottomNavBar(active: 1),
    );
  }
}
