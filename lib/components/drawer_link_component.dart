import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/category_screen.dart';

class DrawerLink extends StatelessWidget {
  DrawerLink({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPress,
  }) : super(key: key);
  String title;
  Icon icon;
  Function onPress;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      onTap: () {
        onPress();
      },
    );
  }
}
