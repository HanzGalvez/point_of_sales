import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/add_order_button.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/invoice_line_model.dart';
import 'package:point_of_sales/screen/checkout_screen.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../components/add_order_qty_modal_components.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../models/product_model.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var qtyController = TextEditingController();
  var barcodeController = TextEditingController();
  List<Product> _productList = [];
  List<InvoiceLine> orderList = [];
  bool _isLoading = true;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    addORder(barcodeScanRes);
  }

  void addORder(String barcodeScanRes) {
    bool barcodeIsValid = false;
    Product? product;
    for (var temp in _productList) {
      if (temp.barcode == barcodeScanRes) {
        product = temp;
        barcodeIsValid = true;
        break;
      }
    }
    if (barcodeIsValid) {
      if (product!.stock <= 0) {
        showAlert(message: '${product.name} is out of stock.');
        return;
      }
      bool productIsNotIn = true;
      for (var order in orderList) {
        if (order.productId == product.id) {
          productIsNotIn = false;
          if ((order.qty + 1) > product.stock) {
            showAlert(message: "The item have only ${product.stock} stock.");
          } else {
            setState(() {
              order.qty += 1;
            });
            break;
          }
        }
      }
      if (productIsNotIn) {
        showDialog(
          context: context,
          builder: (context) {
            return MyAlertQtyModal(
              tempProduct: product!,
              controller: qtyController,
              add: () {
                if (qtyController.text == "") {
                  showAlert(message: "Quantity is required.");
                  return;
                }
                if (int.tryParse(qtyController.text) == null) {
                  showAlert(message: "Invalid Quantity.");
                  return;
                }
                if (int.parse(qtyController.text) <= 0) {
                  showAlert(message: "Can't Add Zero or Negative value.");
                  return;
                }
                int qty = int.parse(qtyController.text);
                if (qty > product!.stock) {
                  showAlert(
                      message: "The items have only ${product.stock} stock");
                  return;
                }
                setState(() {
                  orderList.add(
                    InvoiceLine(
                      productId: product!.id,
                      productPrice: product.price,
                      qty: qty,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } else {
      showAlert(message: 'Item not found');
    }

    setState(() {
      qtyController.clear();
      barcodeController.clear();
    });
  }

  void showAlert({required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
      ),
    );
  }

  void _getProductList() async {
    final data = await ProductDBHelper.getList();
    setState(() {
      _productList = data;
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
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text(
          "Order",
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
        actions: [
          if (orderList.isNotEmpty)
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CheckOutScreen(
                      order: orderList, productList: _productList),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.shopping_cart_checkout_outlined,
                        size: 20,
                      ),
                    ),
                    Text(
                      "Check out",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (orderList.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              width: 1,
              color: Colors.white70,
            ),
          if (_productList.isNotEmpty)
            AddOrderBUtton(
              controller: barcodeController,
              add: () {
                addORder(barcodeController.text);
              },
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green[700],
            ))
          : orderList.isEmpty
              ? Center(
                  child: Text(
                    _productList.isNotEmpty
                        ? 'Scan or add item'
                        : 'You need to add \n product to generate order.',
                    textAlign: TextAlign.center,
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
                    itemCount: orderList.length,
                    itemBuilder: (_, index) {
                      Product item = _productList.singleWhere((element) =>
                          element.id == orderList[index].productId);

                      int sublength =
                          orderList[index].subTotal().toString().length;
                      double subwidth = 85 - sublength.toDouble();

                      return Card(
                        child: Dismissible(
                          confirmDismiss: (direction) {
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Opps..'),
                                  content: Text(
                                      "Are you sure you want to remove ${item.name} ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[700],
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text(
                                        "Ok",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (DismissDirection direction) {
                            setState(() {
                              orderList.removeWhere(
                                  (element) => element.productId == item.id);
                            });
                          },
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            padding: EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                              Icons.delete,
                              color: Color.fromRGBO(229, 57, 53, 1),
                            ),
                          ),
                          key: ValueKey(orderList[index]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Product",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("Qty",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("Sub total",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return MyAlertQtyModal(
                                        qty: orderList[index].qty,
                                        tempProduct: item,
                                        controller: qtyController,
                                        add: () {
                                          if (qtyController.text == "") {
                                            return 2;
                                          } else if (int.tryParse(
                                                  qtyController.text) ==
                                              null) {
                                            return 3;
                                          } else if (int.parse(
                                                  qtyController.text) <=
                                              0) {
                                            return 4;
                                          } else {
                                            int qty =
                                                int.parse(qtyController.text) +
                                                    orderList[index].qty;
                                            if (qty > item.stock) {
                                              return 0;
                                            } else {
                                              setState(() {
                                                orderList[index].qty = qty;
                                              });
                                            }
                                          }
                                          return 1;
                                        },
                                      );
                                    },
                                  );
                                },
                                title: Text(
                                  item.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green[800],
                                  ),
                                ),
                                subtitle: Text(
                                  "Price: ${item.price}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(0, 0, 0, .8),
                                  ),
                                ),
                                trailing: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.remove)),
                                        Text(
                                          " ${orderList[index].qty.toString()}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromRGBO(
                                                0, 0, 0, .8),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.add)),
                                      ],
                                    ),

                                    SizedBox(
                                      width: subwidth,
                                    ),
                                    // ... rest of the ListTile

                                    Text(
                                      " ${orderList[index].subTotal()}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            const Color.fromRGBO(0, 0, 0, .8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[700],
        onPressed: () {
          scanBarcodeNormal();
        },
        child: const Icon(
          Icons.document_scanner_outlined,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(active: -1),
    );
  }
}
