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
        color: Colors.green.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color.fromARGB(255, 3, 64, 5),
            ),
          ],
        ),
      ),
    );
  }
}
