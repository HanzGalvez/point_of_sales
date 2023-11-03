import 'package:flutter/material.dart';
import 'package:point_of_sales/screen/pin_verification_screen.dart';
import 'package:point_of_sales/screen/setpin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

bool havePin = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final preferences = await SharedPreferences.getInstance();
  havePin = preferences.containsKey('pin');
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: havePin ? PinVerificationScreen() : SetPinVerificationScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
      },
    ),
  );
}
