import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/text_field_component.dart';
import 'package:point_of_sales/models/category_model.dart';

class EditCategoryModel extends StatelessWidget {
  EditCategoryModel({Key? key, required this.edit, required this.category})
      : super(key: key);
  Function edit;
  var nameController = TextEditingController();
  var descController = TextEditingController();
  Category category;
  @override
  Widget build(BuildContext context) {
    nameController.text = category.title;
    descController.text = category.description;
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Container(
        color: Colors.white,
        width: width * .75,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Category",
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
              TextFieldComponents(
                controller: nameController,
                label: "Name",
              ),
              TextFieldComponents(
                controller: descController,
                label: "Description",
              ),
              Container(
                height: 45,
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700]),
                  onPressed: () {
                    var temp = Category(
                        id: category.id,
                        title: nameController.text,
                        description: descController.text,
                        icon: 1);
                    edit(temp);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
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
