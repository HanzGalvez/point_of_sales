import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/models/category_model.dart';

class Category_list {
  final int id;
  final String title;
  final Icon icon; // Change to Icon

  Category_list({
    required this.id,
    required this.title,
    required this.icon,
  });
}

class AddStore extends StatefulWidget {
  AddStore({
    Key? key,
    required this.add,
    required this.undo,
  }) : super(key: key);

  final Function add;
  final Function undo;

  @override
  _AddStoreState createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  var nameController = TextEditingController();
  var descController = TextEditingController();
  int selectedCategoryId = 1; // Default category

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Container(
        color: Colors.white,
        width: width * 0.75,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Store",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
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
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Store Name"),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: "Type"),
              ),
              Center(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 20),
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(2, 253, 111, 0.624),
                    ),
                    onPressed: () {
                      if (nameController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text('Category Name is required'),
                            );
                          },
                        );
                        return;
                      }
                      if (descController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text('Category Description is required'),
                            );
                          },
                        );
                        return;
                      }
                      var temp = Category(
                        title: "Sample",
                        description: descController.text,
                        icon: 5,
                      );
                      widget.add(temp);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green[700],
                          content: Text(
                            'Successfully added',
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

                      nameController.clear();
                    },
                    child: Text(
                      "ADD",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
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

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Your logic to show the AddCategoryModel dialog here
            },
            child: Text('Show Add Category Dialog'),
          ),
        ),
      ),
    ),
  );
}
