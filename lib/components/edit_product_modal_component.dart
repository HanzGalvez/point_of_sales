import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:point_of_sales/components/text_field_component.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/product_model.dart';

import '../helpers/categorydb.dart';

class EditProductModal extends StatefulWidget {
  EditProductModal({
    Key? key,
    required this.product,
    required this.onUpdate,
  }) : super(key: key);
  Product product;
  Function onUpdate;

  @override
  State<EditProductModal> createState() => _EditProductModalState();
}

class _EditProductModalState extends State<EditProductModal> {
  var catId = 0;
  var barcodeController = TextEditingController();
  var nameController = TextEditingController();
  var categoryController = TextEditingController();
  var descController = TextEditingController();
  var qtyController = TextEditingController();
  var priceController = TextEditingController();
  var sizeController = TextEditingController();
  var retailPrice = TextEditingController();
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    if (barcodeScanRes != "-1") {
      var checkProduct =
          await ProductDBHelper.checkBarCode(code: barcodeScanRes);
      setState(() {
        if (checkProduct.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              content: Text("Barcode is already assigned."),
            ),
          );
        } else {
          barcodeController.text = barcodeScanRes;
        }
      });
    }
  }

  @override
  void initState() {
    barcodeController.text = widget.product.barcode;
    nameController.text = widget.product.name;
    categoryController.text = widget.product.catId.toString();
    descController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    if (catId == 0) {
      catId = widget.product.catId;
    }
    return AlertDialog(
      content: Container(
        color: Colors.white,
        width: width * .75,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Product",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 0, 0, .7),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Barcode: ",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: (width * .75 - 40) * .75,
                    child: TextField(
                      enabled: false,
                      controller: barcodeController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      scanBarcodeNormal();
                    },
                    icon: const Icon(
                      Icons.document_scanner_outlined,
                      color: Color.fromRGBO(56, 142, 60, 1),
                    ),
                  ),
                ],
              ),
              TextFieldComponents(
                label: "Name",
                controller: nameController,
              ),
              Text(
                "Category: ",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              FutureBuilder(
                future: CategoryDBHelper.getList(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> category) {
                  if (category.hasData) {
                    if (category.data!.isNotEmpty) {
                      bool isIn = false;
                      for (var element in category.data!) {
                        if (element[CategoryDBHelper.colId] == catId) {
                          isIn = true;
                          break;
                        }
                      }
                      if (!isIn) {
                        catId = category.data!.first[CategoryDBHelper.colId];
                      }
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: category.data!.isEmpty
                          ? const Text("You must add categories.")
                          : DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                // Initial Value
                                value: catId,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: category.data!.map((item) {
                                  return DropdownMenuItem(
                                    value: item['id']!,
                                    child: Text(item['title']!),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    catId = int.parse(value.toString());
                                  });
                                },
                              ),
                            ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              TextFieldComponents(
                label: "Description",
                controller: descController,
              ),
              TextFieldComponents(
                label: "Price",
                controller: priceController,
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
                    List<TextEditingController> inputList = [
                      barcodeController,
                      nameController,
                      descController,
                      priceController
                    ];
                    final List<String> error = [
                      'Barcode is required',
                      'Name is required',
                      'Description is required',
                      'Price is required',
                    ];
                    bool isOk = true;
                    for (int i = 0; i < inputList.length; i++) {
                      if (inputList[i].text == "") {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text(error[i]),
                          ),
                        );
                        isOk = false;
                        break;
                      }
                    }
                    if (isOk) {
                      if (double.tryParse(inputList[3].text.toString()) ==
                          null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("Invalid Price. Check your input"),
                          ),
                        );
                        return;
                      }
                      if (double.parse(inputList[3].text.toString()) <= 0) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("Price cannot be negative."),
                          ),
                        );
                        return;
                      }

                      var temp = Product(
                        id: widget.product.id,
                        barcode: barcodeController.text,
                        name: nameController.text,
                        catId: catId,
                        description: descController.text,
                        price: double.parse(priceController.text),
                        measurement: sizeController.text,
                        retailPrice: double.parse(retailPrice.text),
                      );
                      ProductDBHelper.update(temp);
                      widget.onUpdate();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green[700],
                          content: Text(
                            'Successfuly Edited',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Save",
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
