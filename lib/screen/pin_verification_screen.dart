import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinVerificationScreen extends StatelessWidget {
  const PinVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.track_changes_outlined,
                    size: 100,
                    color: Colors.green[700],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "iTrack: Sales Tracker",
                    style: GoogleFonts.lato(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Pin Number Verification",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter your pin: ",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 30),
                    width: 300,
                    child: PinCodeFields(
                      fieldBackgroundColor: Colors.grey[300],
                      fieldHeight: 50,
                      fieldBorderStyle: FieldBorderStyle.square,
                      borderWidth: 0,
                      borderRadius: BorderRadius.circular(10),
                      borderColor: Colors.blueGrey,
                      keyboardType: TextInputType.number,
                      activeBorderColor: Colors.black,
                      activeBackgroundColor: Colors.grey,
                      onComplete: (value) async {
                        if (value.length == 4) {
                          final prefernces =
                              await SharedPreferences.getInstance();
                          String? pin = prefernces.getString('pin');
                          if (pin == value) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Text(
                                        'INCORRECT PIN!',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 205, 14, 0)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                          }
                        }
                      },
                    ),
                  ),
                  // Container(
                  //   height: 45,
                  //   width: 300,
                  //   decoration: BoxDecoration(
                  //     color: Colors.green[700],
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.of(context).pushReplacement(
                  //         MaterialPageRoute(
                  //           builder: (context) => HomeScreen(),
                  //         ),
                  //       );
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       elevation: 0,
                  //       backgroundColor: Colors.green[700],
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(15),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       "Verify",
                  //       style: GoogleFonts.poppins(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
