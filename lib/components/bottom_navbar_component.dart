import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/screen/home_screen.dart';
import 'package:point_of_sales/screen/inventory_screen.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key, required this.active}) : super(key: key);
  int active;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.black54,
      selectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      onTap: (value) {
        if (value == 0) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else if (value == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => InventoryScreen(),
            ),
          );
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Icon(
              Icons.home,
              color: active == 0 ? Colors.green[700] : Colors.black54,
              size: 20,
            ),
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Icon(
              Icons.inventory,
              color: active == 1 ? Colors.green[700] : Colors.black54,
              size: 20,
            ),
          ),
          label: "Inventory",
        ),
      ],
    );
  }
}
