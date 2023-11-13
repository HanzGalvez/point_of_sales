import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/edit_category_modal_component.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/models/category_model.dart';

import 'package:point_of_sales/screen/category_product_list_screen.dart';
import '../components/add_category_modal_component.dart';
import '../components/add_store_modal_component.dart';
import '../components/bottom_navbar_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';

class Switchstore extends StatefulWidget {
  Switchstore({super.key});

  @override
  State<Switchstore> createState() => _SwitchstoreState();
}

class _SwitchstoreState extends State<Switchstore> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: CategoryDBHelper.getList(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> list) {
        if (list.hasData) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
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
              centerTitle: true,
              title: Text(
                "STORES",
                style: GoogleFonts.lato(
                  fontSize: 18,
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
            body: list.data!.isEmpty
                ? Center(
                    child: Text(
                      'Store is empty',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: Card(
                          child: Dismissible(
                            confirmDismiss: (direction) {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Opps..'),
                                    content: Text(
                                        "Are you sure you want to delete Dick's Store ?"),
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
                            background: Container(
                              padding: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: const Icon(
                                Icons.delete,
                                color: Color.fromRGBO(229, 57, 53, 1),
                              ),
                            ),
                            key: ValueKey(1),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) async {
                              await CategoryDBHelper.delete(1);
                              setState(() {});
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Rounded corners
                              ),
                              tileColor: Color.fromRGBO(213, 236, 223, 100),
                              leading: Icon(Icons.store),
                              onTap: () {
                                AlertDialog(
                                  title: Text('Confirmation'),
                                  content: Text(
                                      "Are you sure you want to switch to Second Store ?"),
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
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Dick's Store",
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
                              subtitle: Text(
                                "Sari-sari Store",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.edit_note_outlined,
                                  color: Color.fromRGBO(58, 152, 63, 1),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Card(
                          child: Dismissible(
                            confirmDismiss: (direction) {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Opps..'),
                                    content: Text(
                                        "Are you sure you want to delete Second Store ?"),
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
                            background: Container(
                              padding: EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: const Icon(
                                Icons.delete,
                                color: Color.fromRGBO(229, 57, 53, 1),
                              ),
                            ),
                            key: ValueKey(1),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) async {
                              await CategoryDBHelper.delete(1);
                              setState(() {});
                            },
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12.0), // Rounded corners
                              ),
                              tileColor: Color.fromRGBO(213, 236, 223, 100),
                              leading: Icon(Icons.store),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                            "Are you sure you want to switch to Second Store ?"),
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
                                              backgroundColor:
                                                  Colors.green[700],
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
                                    "Second Store",
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                "School Supplies Store",
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.edit_note_outlined,
                                  color: Color.fromRGBO(58, 152, 63, 1),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Card(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Rounded corners
                            ),
                            tileColor: Color.fromRGBO(213, 236, 223, 100),
                            leading: Icon(Icons.add_circle_sharp),
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  int addedId = 0;
                                  return AddStore(
                                    add: (temp) async {
                                      addedId =
                                          await CategoryDBHelper.insert(temp);
                                      setState(() {});
                                    },
                                    undo: () {
                                      if (addedId != 0) {
                                        setState(() {
                                          CategoryDBHelper.delete(addedId);
                                        });
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Add New Store",
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            drawer: MyDrawer(),
            floatingActionButton: MyFloatingActionOrder(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomNavBar(active: -1),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                  color: Color.fromRGBO(56, 142, 60, 1)),
            ),
          );
        }
      },
    );
  }
}
