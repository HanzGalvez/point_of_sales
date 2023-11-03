import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sales/screen/home_screen.dart';
import 'package:point_of_sales/screen/pin_verification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/table_handler.dart';

class SetPinVerificationScreen extends StatefulWidget {
  SetPinVerificationScreen({super.key});

  @override
  State<SetPinVerificationScreen> createState() =>
      _SetPinVerificationScreenState();
}

class _SetPinVerificationScreenState extends State<SetPinVerificationScreen> {
  String pin = "";
  void createDb() async {
    await DatabaseHandler.createDB();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDb();
  }

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
                    "Set Up Your Pin",
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
                      keyboardType: TextInputType.number,
                      activeBorderColor: Colors.green,
                      onComplete: (value) {
                        pin = value;
                      },
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefernces =
                            await SharedPreferences.getInstance();
                        prefernces.setString('pin', pin);
                        print(pin);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => PinVerificationScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
