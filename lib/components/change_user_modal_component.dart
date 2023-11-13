import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/models/category_model.dart';

class ChangeUser extends StatefulWidget {
  ChangeUser({super.key});

  @override
  _ChangeUserState createState() => _ChangeUserState();
}

class _ChangeUserState extends State<ChangeUser> {
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
                    "User Accounts",
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
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                tileColor: Color.fromRGBO(213, 236, 223, 100),
                leading: Icon(Icons.person),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text(
                              "Are you sure you want to switch to Dick Lomibao ?"),
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
                      }));
                },
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Dick Lomibao",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[700],
                    )
                  ],
                ),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                tileColor: Color.fromRGBO(213, 236, 223, 100),
                leading: Icon(Icons.person),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text(
                              "Are you sure you want to switch to Hanz Galvez ?"),
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
                      }));
                },
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Hanz Galvez",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
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
