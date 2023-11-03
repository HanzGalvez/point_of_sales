import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Category {
  final int id;
  final String name;
  final Icon icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class AddCategoryModel extends StatefulWidget {
  AddCategoryModel({
    Key? key,
    required this.add,
    required this.undo,
  }) : super(key: key);

  final Function add;
  final Function undo;

  @override
  _AddCategoryModelState createState() => _AddCategoryModelState();
}

class _AddCategoryModelState extends State<AddCategoryModel> {
  var nameController = TextEditingController();
  var descController = TextEditingController();
  int selectedCategoryId = 1; // Default category

  final List<Category> categories = [
    Category(
      id: 1,
      name: 'Drinks',
      icon: Icon(Icons.local_drink),
    ),
    Category(
      id: 2,
      name: 'Bread',
      icon: Icon(Icons.local_dining),
    ),
    Category(
      id: 3,
      name: 'Junk Foods',
      icon: Icon(Icons.fastfood),
    ),
  ];

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
                    "Add Category",
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
              DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: selectedCategoryId,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: categories.map((Category category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Row(
                        children: [
                          category.icon,
                          SizedBox(width: 10),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (int? categoryId) {
                    setState(() {
                      selectedCategoryId = categoryId!;
                    });
                  },
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
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
                    var selectedCategory = categories.firstWhere(
                        (category) => category.id == selectedCategoryId);
                    var temp = Category(
                      id: selectedCategory.id,
                      name: nameController.text,
                      icon: selectedCategory.icon,
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
                  },
                  child: Text(
                    "Add item",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
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
