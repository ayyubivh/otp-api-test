import 'package:flutter/material.dart';
import 'package:sample_test/otp_screen.dart';
import 'package:sample_test/pallete.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallet.backgroundColor,
      appBar: AppBar(backgroundColor: Pallet.backgroundColor, actions: [
        IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx1) {
                    return AlertDialog(
                      content: Text('Are you sure you want to logout'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OtpScreen()),
                                (route) => false,
                              );
                              final sharedPrefs =
                                  await SharedPreferences.getInstance();
                              await sharedPrefs.clear();
                            },
                            child: Text('logout')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx1).pop();
                            },
                            child: Text('No')),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.logout))
      ]),
      body: const Center(
        child: Text(
          "Home Screen",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
