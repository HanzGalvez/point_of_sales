import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditsPaymentModal extends StatelessWidget {
  CreditsPaymentModal({super.key});

  var partialpayment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Container(
        color: Colors.white,
        width: width * 0.75,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: partialpayment,
                decoration: InputDecoration(labelText: "Payment"),
              ),
              Center(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 20),
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(2, 253, 111, 0.624),
                    ),
                    onPressed: () {
                      if (partialpayment.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text('Payment is required'),
                            );
                          },
                        );
                        return;
                      }

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green[700],
                          content: Text(
                            'Successfully deducted',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          action: SnackBarAction(
                            textColor: Colors.white,
                            label: 'Undo',
                            onPressed: () {
                              // widget
                              //     .undo();
                            },
                          ),
                        ),
                      );

                      partialpayment.clear();
                    },
                    child: Text(
                      "Pay",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
