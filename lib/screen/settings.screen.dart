import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/helpers/invoicedb.dart';
import 'package:point_of_sales/helpers/invoicelinedb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:uuid/uuid.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreenn extends StatefulWidget {
  const SettingsScreenn({super.key});

  @override
  State<SettingsScreenn> createState() => _SettingsScreennState();
}

class _SettingsScreennState extends State<SettingsScreenn> {
  var key = TextEditingController();
  SharedPreferences? _prefs;

  String? id;
  void alertInternet(String msg) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"))
          ],
          title: Text("Oops.."),
          content: Text(msg),
        );
      },
    );
  }

  void setGEtKey() async {
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs!.containsKey("appid")) {
      await _prefs!.setString("appid", Uuid().v4());
      id = _prefs!.getString("appid");
    }
    id = _prefs!.getString("appid");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setGEtKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text('App id:\n${id}'),
                  );
                },
              );
            },
            icon: Icon(Icons.info_outline),
          )
        ],
        backgroundColor: Colors.green[700],
        title: Text(
          "Settings",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.green[700],
                ),
                onPressed: () async {
                  try {
                    final response =
                        await InternetAddress.lookup('www.google.com');
                    if (response.isNotEmpty) {
                      final category = await CategoryDBHelper.getList();
                      final product = await ProductDBHelper.storeInFirebase();
                      final invoice = await InvoiceDBHelper.storeInFirebase();
                      final line = await InvoiceLineDBHelper.storeInFirebase();

                      category.forEach((element) {
                        FirebaseFirestore.instance
                            .collection('category')
                            .doc(id)
                            .collection('category')
                            .doc(element[CategoryDBHelper.colId].toString())
                            .set(element);
                      });
                      product.forEach((element) {
                        FirebaseFirestore.instance
                            .collection('product')
                            .doc(id)
                            .collection('product')
                            .doc(element[ProductDBHelper.colId].toString())
                            .set(element);
                      });
                      invoice.forEach((element) {
                        FirebaseFirestore.instance
                            .collection('invoice')
                            .doc(id)
                            .collection('invoice')
                            .doc(element[InvoiceDBHelper.colId].toString())
                            .set(element);
                      });
                      line.forEach((element) {
                        FirebaseFirestore.instance
                            .collection('invoiceLine')
                            .doc(id)
                            .collection('invoiceLine')
                            .doc(element[InvoiceLineDBHelper.colId].toString())
                            .set(element);
                      });

                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Ok"))
                            ],
                            title: Text("Success"),
                            content: Text(
                                "Your data is now exported on cloud firestore"),
                          );
                        },
                      );
                    }
                  } on SocketException catch (err) {
                    alertInternet("Please check your internet Connection");
                  }
                },
                child: Text(
                  "Back up Data ",
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                              ),
                              onPressed: () async {
                                try {
                                  final response = await InternetAddress.lookup(
                                      'www.google.com');
                                  if (response.isNotEmpty) {
                                    final category = await FirebaseFirestore
                                        .instance
                                        .collection("category")
                                        .doc(key.text)
                                        .collection("category")
                                        .get();
                                    final product = await FirebaseFirestore
                                        .instance
                                        .collection("product")
                                        .doc(key.text)
                                        .collection("product")
                                        .get();
                                    final invoice = await FirebaseFirestore
                                        .instance
                                        .collection("invoice")
                                        .doc(key.text)
                                        .collection("invoice")
                                        .get();
                                    final invoiceLine = await FirebaseFirestore
                                        .instance
                                        .collection("invoiceLine")
                                        .doc(key.text)
                                        .collection("invoiceLine")
                                        .get();

                                    if (category.docs.isEmpty &&
                                        product.docs.isEmpty &&
                                        invoice.docs.isEmpty &&
                                        invoiceLine.docs.isEmpty) {
                                      return alertInternet(
                                          "Check your provided key.");
                                    } else {
                                      category.docs.forEach((element) async {
                                        await CategoryDBHelper.firestoreInsert(
                                            element.data());
                                      });
                                      product.docs.forEach((element) async {
                                        await ProductDBHelper.firestoreInsert(
                                            element.data());
                                      });
                                      invoice.docs.forEach((element) async {
                                        await InvoiceDBHelper.firestoreInsert(
                                            element.data());
                                      });
                                      invoiceLine.docs.forEach((element) async {
                                        await InvoiceLineDBHelper
                                            .firestoreInsert(element.data());
                                      });

                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actions: [
                                              OutlinedButton(
                                                  onPressed: () {
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                            context,
                                                            '/home',
                                                            (route) => false);
                                                  },
                                                  child: Text("Ok"))
                                            ],
                                            content:
                                                Text("Data succesfully fetch."),
                                          );
                                        },
                                      );
                                    }
                                  }
                                } on SocketException catch (err) {
                                  alertInternet(
                                      "Please check your internet Connection");
                                }
                              },
                              child: Text("Fetch data"),
                            ),
                          ],
                          content: TextField(
                            controller: key,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Your key'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "Get data online",
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.green[700],
                  ),
                ),
              )),
        ],
      ),
      drawer: MyDrawer(),
      floatingActionButton: MyFloatingActionOrder(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(active: -1),
    );
  }
}
