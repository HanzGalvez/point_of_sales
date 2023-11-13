import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/components/edit_category_modal_component.dart';
import 'package:point_of_sales/components/newcustomer_modal_componet.dart';
import 'package:point_of_sales/helpers/categorydb.dart';
import 'package:point_of_sales/models/category_model.dart';

import 'package:point_of_sales/screen/category_product_list_screen.dart';
import '../components/add_category_modal_component.dart';
import '../components/add_store_modal_component.dart';
import '../components/bottom_navbar_component.dart';
import '../components/credits_payment_modal_component.dart';
import '../components/drawer_component.dart';
import '../components/floating_action_order_component.dart';
import 'credit_details.dart';

class CreditsScreen extends StatefulWidget {
  CreditsScreen({super.key});

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  var partialpayment = TextEditingController();
  var newcustomer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: CategoryDBHelper.getList(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> list) {
        if (list.hasData) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                bottom: TabBar(
                  tabs: [Tab(text: "UNPAID"), Tab(text: "PAID")],
                ),
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
                  "CREDITS",
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
                actions: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          int addedId = 0;
                          return NewCutomerModal();
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add,
                            size: 22,
                          ),
                          Text(
                            "New",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                  : TabBarView(children: [
                      //Paid
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 10),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    hintStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, left: 8.0),
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
                                                Navigator.of(context)
                                                    .pop(false);
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
                                    tileColor:
                                        Color.fromRGBO(213, 236, 223, 100),
                                    leading: Icon(Icons.person),
                                    onTap: () {
                                      AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                            "Are you sure you want to switch to Hanz Account ?"),
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
                                    },
                                    subtitle: Text("Credit: P500.00"),
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Ashley",
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: PopupMenuButton(
                                      icon: Icon(Icons
                                          .more_vert), // 3-dot vertical icon
                                      itemBuilder: (BuildContext context) {
                                        return <PopupMenuEntry>[
                                          PopupMenuItem(
                                            value: 'paid',
                                            child: Text('Paid'),
                                          ),
                                          PopupMenuItem(
                                            value: 'partial',
                                            child: Text('Partial'),
                                          ),
                                          PopupMenuItem(
                                            value: 'add',
                                            child: Text('Add Item'),
                                          ),
                                        ];
                                      },
                                      onSelected: (value) {
                                        if (value == 'paid') {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CreditsPaymentModal();
                                            },
                                          );
                                        } else if (value == 'partial') {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CreditsPaymentModal();
                                            },
                                          );
                                        } else if (value == 'add') {}
                                      },
                                    ),
                                    // trailing: IconButton(
                                    //   icon: const Icon(
                                    //     Icons.edit_note_outlined,
                                    //     color: Color.fromRGBO(58, 152, 63, 1),
                                    //   ),
                                    //   onPressed: () {
                                    //     Navigator.push(context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) {
                                    //       return CreditDetailsScreen();
                                    //     }));
                                    //   },
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                                Navigator.of(context)
                                                    .pop(false);
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
                                    tileColor:
                                        Color.fromRGBO(213, 236, 223, 100),
                                    leading: Icon(Icons.person),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return CreditDetailsScreen();
                                      }));
                                    },
                                    subtitle: Text("Credit: P100.00"),
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Bon",
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // trailing: IconButton(
                                    //   icon: const Icon(
                                    //     Icons.edit_note_outlined,
                                    //     color: Color.fromRGBO(58, 152, 63, 1),
                                    //   ),
                                    //   onPressed: () {
                                    //     Navigator.push(context,
                                    //         MaterialPageRoute(
                                    //       builder: (context) {
                                    //         return CreditDetailsScreen();
                                    //       },
                                    //     ));
                                    //   },
                                    // ),
                                    trailing: PopupMenuButton(
                                      icon: Icon(Icons
                                          .more_vert), // 3-dot vertical icon
                                      itemBuilder: (BuildContext context) {
                                        return <PopupMenuEntry>[
                                          PopupMenuItem(
                                            value: 'paid',
                                            child: Text('Paid'),
                                          ),
                                          PopupMenuItem(
                                            value: 'partial',
                                            child: Text('Partial'),
                                          ),
                                          PopupMenuItem(
                                            value: 'add',
                                            child: Text('Add Item'),
                                          ),
                                          // Add more menu items as needed
                                        ];
                                      },
                                      onSelected: (value) {
                                        if (value == 'paid') {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CreditsPaymentModal();
                                            },
                                          );
                                        } else if (value == 'partial') {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CreditsPaymentModal();
                                            },
                                          );
                                        } else if (value == 'add') {}
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Unpaid

                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 10),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    hintStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, left: 8.0),
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
                                                Navigator.of(context)
                                                    .pop(false);
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
                                    tileColor:
                                        Color.fromRGBO(213, 236, 223, 100),
                                    leading: Icon(Icons.person),
                                    onTap: () {
                                      AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                            "Are you sure you want to switch to Hanz Account ?"),
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
                                    },
                                    subtitle: Text("Paid"),
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Mark Racca",
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.check_box,
                                        color: Color.fromRGBO(58, 152, 63, 1),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
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
                                                Navigator.of(context)
                                                    .pop(false);
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
                                    tileColor:
                                        Color.fromRGBO(213, 236, 223, 100),
                                    leading: Icon(Icons.person),
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
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green[700],
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: Text(
                                                    "Ok",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          }));
                                    },
                                    subtitle: Text("Paid"),
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Lindsay",
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.check_box,
                                        color: Color.fromRGBO(58, 152, 63, 1),
                                      ),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return CreditDetailsScreen();
                                          },
                                        ));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              drawer: MyDrawer(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomNavBar(active: -1),
            ),
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
