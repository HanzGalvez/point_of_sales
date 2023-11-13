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

  static final List<Category_list> categories = [
    Category_list(
      id: 0,
      title: 'Add New',
      icon: Icon(Icons.add),
    ),
    Category_list(
      id: 1,
      title: 'Drinks',
      icon: Icon(Icons.local_drink),
    ),
    Category_list(
      id: 2,
      title: 'Bread',
      icon: Icon(Icons.local_dining),
    ),
    Category_list(
      id: 3,
      title: 'Junk Foods',
      icon: Icon(Icons.fastfood),
    ),
    Category_list(
      id: 4,
      title: 'Fruits',
      icon: Icon(Icons.local_florist),
    ),
    Category_list(
      id: 5,
      title: 'Vegetables',
      icon: Icon(Icons.eco),
    ),
    Category_list(
      id: 6,
      title: 'Meat',
      icon: Icon(Icons.shopping_cart),
    ),
    Category_list(
      id: 7,
      title: 'Dairy',
      icon: Icon(Icons.local_mall),
    ),
    Category_list(
      id: 8,
      title: 'Cereal',
      icon: Icon(Icons.local_pizza),
    ),
    Category_list(
      id: 9,
      title: 'Canned Goods',
      icon: Icon(Icons.anchor),
    ),
    Category_list(
      id: 10,
      title: 'Snacks',
      icon: Icon(Icons.fastfood),
    ),
    Category_list(
      id: 11,
      title: 'Bakery',
      icon: Icon(Icons.cake),
    ),
    Category_list(
      id: 12,
      title: 'Personal Care',
      icon: Icon(Icons.accessibility),
    ),
    Category_list(
      id: 13,
      title: 'Cleaning Supplies',
      icon: Icon(Icons.cleaning_services),
    ),
    Category_list(
      id: 14,
      title: 'Health and Wellness',
      icon: Icon(Icons.healing),
    ),
    Category_list(
      id: 15,
      title: 'Household',
      icon: Icon(Icons.home),
    ),
    Category_list(
      id: 16,
      title: 'Baby Care',
      icon: Icon(Icons.child_friendly),
    ),
    Category_list(
      id: 17,
      title: 'Pet Supplies',
      icon: Icon(Icons.pets),
    ),
    Category_list(
      id: 18,
      title: 'Frozen Foods',
      icon: Icon(Icons.ac_unit),
    ),
    Category_list(
      id: 19,
      title: 'Condiments',
      icon: Icon(Icons.restaurant),
    ),
    Category_list(
      id: 20,
      title: 'Spices',
      icon: Icon(Icons.restaurant_menu),
    ),
    // Add more categories as needed
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
              DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: selectedCategoryId,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: categories.map((Category_list category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: category.id == 0
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Enter a category"),
                                      content: TextField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                            labelText: "Name",
                                            prefixIcon: Icon(Icons.shopify)),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                int newCatId =
                                                    categories.length + 1;

                                                categories.add(Category_list(
                                                    id: categories.length + 1,
                                                    title: nameController.text,
                                                    icon: Icon(Icons.shopify)));

                                                selectedCategoryId = newCatId!;
                                              });

                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Done",
                                              style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ))
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  category.icon,
                                  SizedBox(width: 10),
                                  Text(category.title), // Change to title
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                category.icon,
                                SizedBox(width: 10),
                                Text(category.title), // Change to title
                              ],
                            ),
                    );
                  }).toList(),
                  onChanged: (int? categoryId) {
                    setState(() {
                      selectedCategoryId = categoryId!;

                      for (int i = 0; i < categories.length; i++) {
                        if (categories[i].id == categoryId) {
                          nameController.text = categories[i].title;
                        }
                      }
                    });
                  },
                ),
              ),
              // TextField(
              //   controller: nameController,
              //   decoration: InputDecoration(labelText: "Name"),
              // ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: "Description"),
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
                      var selectedCategory = categories.firstWhere(
                          (category) => category.id == selectedCategoryId);

                      if (selectedCategoryId > 20) {
                        selectedCategoryId = 0;
                      }

                      var temp = Category(
                        title: selectedCategory.title,
                        description: descController.text,
                        icon: selectedCategoryId,
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
