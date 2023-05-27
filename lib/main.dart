import 'package:flutter/material.dart';
import 'package:sample_test/home_screen.dart';
import 'package:sample_test/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SAVE_KEY_NAME = 'jwt';
void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

String? jwt;

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  Future<void> checkLogin() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final userLoggedIn = sharedPrefs.getString(SAVE_KEY_NAME);
    setState(() {
      jwt = userLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: jwt == null ? const OtpScreen() : const HomeScreen());
  }
}
