import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/screen/home_screen.dart';

class AlertSuccessModal extends StatelessWidget {
  AlertSuccessModal({super.key, required this.change});
  double change;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Text(
          'Transaction success',
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Colors.green[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Container(
          width: width * .75,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Change: ${change}",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(top: 30),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700]),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    },
                    child: Text(
                      "Ok",
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
      ),
    );
  }
}
