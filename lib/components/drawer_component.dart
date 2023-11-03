import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/screen/settings.screen.dart';
import 'package:point_of_sales/screen/transaction_screen.dart';
import '../screen/product_screen.dart';
import '../screen/sales_screen.dart';
import '/screen/category_screen.dart';

import 'drawer_link_component.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: Color.fromRGBO(56, 142, 60, 1),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(56, 142, 60, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.track_changes_outlined,
                  color: Colors.white,
                  size: 70,
                ),
                Center(
                  child: Text(
                    "iTrack",
                    style: GoogleFonts.lato(fontSize: 35, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            color: Colors.white,
            height: height * .75,
            child: Column(
              children: [
                DrawerLink(
                  icon: const Icon(Icons.category_outlined),
                  title: "Category",
                  onPress: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(),
                      ),
                    );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.view_list_outlined),
                  title: "Product",
                  onPress: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ProductScreen(),
                      ),
                    );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.card_travel_outlined),
                  title: "Transaction",
                  onPress: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => TransactionScreen(),
                      ),
                    );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.money_outlined),
                  title: "Sales",
                  onPress: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SalesScreen(),
                      ),
                    );
                  },
                ),
                DrawerLink(
                  icon: const Icon(Icons.settings),
                  title: "Settings",
                  onPress: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SettingsScreenn(),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
