import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sample_test/home_screen.dart';
import 'package:sample_test/pallete.dart';
import 'package:sample_test/widgets/eleveted_button.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameTexteditingController = TextEditingController();
    TextEditingController emailTexteditingController = TextEditingController();

    // String jwtToken = '';
    void submitProfile(String name, String email) async {
      var url = Uri.parse('https://test-otp-api.7474224.xyz/profilesubmit.php');

      // Define the request body
      var requestBody = {
        "name": name,
        "email": email,
      };

      // Define the request headers
      var headers = {"Token": "jwt1235"};

      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        // Handle the response data here
        print(jsonResponse);
      } else {
        // Handle the error or non-200 status code here
        print('Request failed with status: ${response.statusCode}');
      }
    }

    final size = MediaQuery.of(context).size;
    var sizedBox = SizedBox(
      height: size.height / 40,
    );
    return Scaffold(
      backgroundColor: Pallet.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            sizedBox,
            Text(
              'Looks like you are new here. Tell us a bit about yourself.',
              style:
                  TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
            ),
            sizedBox,
            textformField("Name", nameTexteditingController),
            sizedBox,
            textformField("Email", emailTexteditingController),
            sizedBox,
            CustomElevatedButton(
              text: "Sign In",
              onPress: () {
                submitProfile(nameTexteditingController.text,
                    emailTexteditingController.text);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget textformField(String hintText, TextEditingController controller) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Pallet.borderColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Pallet.gradient2,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
          )),
    );
  }
}
