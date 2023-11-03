import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class gridNavBArCard extends StatelessWidget {
  gridNavBArCard(
      {Key? key, required this.icon, required this.title, required this.goto})
      : super(key: key);
  IconData icon;
  String title;
  Widget goto;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => goto,
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: Colors.green[700],
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(0, 0, 0, .7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
