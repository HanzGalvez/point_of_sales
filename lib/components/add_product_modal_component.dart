import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:point_of_sales/components/text_field_component.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/helpers/productdb.dart';
import 'package:point_of_sales/models/product_model.dart';

class AddProductModel extends StatefulWidget {
  AddProductModel({Key? key, required this.add, required this.undo})
      : super(key: key);

  Function add;
  Function undo;
  @override
  State<AddProductModel> createState() => _AddProductModelState();
}

class _AddProductModelState extends State<AddProductModel> {
  var barcodeController = TextEditingController();
  var nameController = TextEditingController();
  var categoryController = TextEditingController();
  var descController = TextEditingController();
  var sizeController = TextEditingController();
  var qtyController = TextEditingController();
  var priceController = TextEditingController();
  var retailPrice = TextEditingController();
  var catId = 0;
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
      if (await validateCode(barcodeScanRes)) {
        setState(() {
          barcodeController.text = barcodeScanRes;
        });
      }
    }
  }

  Future<bool> validateCode(String code) async {
    var checkProduct = await ProductDBHelper.checkBarCode(code: code);

    if (checkProduct.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Barcode is already assigned."),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
                    "Add Product",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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
                      onChanged: (value) async {
                        if (!await validateCode(value)) {
                          setState(() {
                            barcodeController.text = "";
                          });
                        }
                      },
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
                    if (catId == 0 && category.data!.isNotEmpty) {
                      catId = category.data![0]['id'];
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
                                  catId = int.parse(value.toString());
                                  setState(() {});
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
                label: "Size/Unit of Measurement",
                controller: sizeController,
              ),
              TextFieldComponents(
                label: "Quantity",
                controller: qtyController,
                keyboardType: TextInputType.number,
              ),
              TextFieldComponents(
                label: "Retail Price",
                controller: retailPrice,
                keyboardType: TextInputType.number,
              ),
              TextFieldComponents(
                label: "Selling Price",
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
                      qtyController,
                      priceController
                    ];
                    final List<String> error = [
                      'Barcode is required',
                      'Name is required',
                      'Description is required',
                      'Quatity is required',
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
                      if (catId == 0) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("Category is required"),
                          ),
                        );
                        return;
                      }
                      if (int.tryParse(inputList[3].text.toString()) == null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content:
                                Text("Invalid Quantity. Positive integer only"),
                          ),
                        );
                        return;
                      }
                      if (int.parse(inputList[3].text.toString()) < 0) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("Quantity cannot be negative."),
                          ),
                        );
                        return;
                      }
                      if (double.tryParse(inputList[4].text.toString()) ==
                          null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("Invalid Price. Check your input"),
                          ),
                        );
                        return;
                      }
                      if (double.parse(inputList[4].text.toString()) <= 0) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("Price cannot be negative."),
                          ),
                        );
                        return;
                      }
                      var temp = Product(
                        barcode: barcodeController.text,
                        name: nameController.text,
                        catId: catId,
                        description: descController.text,
                        stock: int.parse(qtyController.text),
                        price: double.parse(priceController.text),
                        measurement: sizeController.text,
                        retailPrice: double.parse(retailPrice.text),
                      );
                      widget.add(temp);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green[700],
                          content: Text(
                            'Successfuly added',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          action: SnackBarAction(
                            textColor: Colors.white,
                            label: 'Undo',
                            onPressed: () {
                              widget.undo();
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Add item",
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
