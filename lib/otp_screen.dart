import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sample_test/home_screen.dart';
import 'package:sample_test/login_screen.dart';
import 'package:sample_test/main.dart';
import 'package:sample_test/pallete.dart';
import 'package:sample_test/widgets/eleveted_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  double bottom = 0;
  double screenHeight = 0;
  double screenWidth = 0;
  String reqId = "";
  String countryDial = "+1";

  int screenState = 0;
  Future<void> sendOTP(String mobileNo) async {
    try {
      const url = 'https://test-otp-api.7474224.xyz/sendotp.php';
      final body = {'mobile': mobileNo};
      final response = await http.post(Uri.parse(url), body: jsonEncode(body));
      print(' ${response.body}');
      final responseData = json.decode(response.body);
      final requestId = responseData['request_id'];

      setState(() {
        reqId = requestId;
      });
      print(responseData['response']);
      print('OTP sent successfully. Request ID:  $requestId');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      var url = Uri.parse('https://test-otp-api.7474224.xyz/verifyotp.php');

      var response = await http.post(
        url,
        body: jsonEncode({
          "request_id": reqId,
          'code': otp,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        String jwt = jsonResponse['jwt'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(SAVE_KEY_NAME, jwt);
        if (jsonResponse['profile_exists'] == true) {
          // Store JWT in shared preferences

          return true;
        } else {
          return false;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Pallet.gradient1,
              Pallet.gradient3,
              Pallet.gradient2,
            ],
          ),
        ),
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight / 8),
                  child: Column(
                    children: [
                      Text(
                        "JOIN US",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth / 8,
                        ),
                      ),
                      Text(
                        "Create an account today!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: circle(5),
              ),
              Transform.translate(
                offset: const Offset(30, -30),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: circle(4.5),
                ),
              ),
              Center(
                child: circle(3),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  height: bottom > 0 ? screenHeight : screenHeight / 2,
                  width: screenWidth,
                  color: Colors.black,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth / 12,
                      right: screenWidth / 12,
                      top: bottom > 0 ? screenHeight / 12 : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        screenState == 0 ? stateRegister() : stateOTP(),
                        Padding(
                            padding: EdgeInsets.only(bottom: screenHeight / 12),
                            child: screenState == 0
                                ? CustomElevatedButton(
                                    text: "Continue",
                                    onPress: () {
                                      if (mobileController.text.length != 10) {
                                        showSnackBarText(
                                            "mobile number must be 10 numbers!");
                                      } else {
                                        sendOTP(mobileController.text);
                                        setState(() {
                                          screenState = 1;
                                        });
                                      }
                                    },
                                  )
                                : const SizedBox())
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget stateRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "Phone number",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        IntlPhoneField(
          dropdownTextStyle: const TextStyle(color: Colors.white),
          style: const TextStyle(color: Colors.white),
          controller: mobileController,
          showCountryFlag: false,
          showDropdownIcon: false,
          initialValue: countryDial,
          onCountryChanged: (country) {
            setState(() {
              countryDial = "+${country.dialCode}";
            });
          },
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.white),
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
          ),
        ),
      ],
    );
  }

  Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Enter OTP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const TextSpan(
                  text: "\nOTP has been sent to",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  )),
              TextSpan(
                  text: " ${mobileController.text}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        PinCodeTextField(
          textStyle: const TextStyle(color: Colors.white),
          // backgroundColor: Colors.white,
          controller: otpController,
          appContext: context,
          length: 6,
          onChanged: (value) {
            setState(() {});
          },
          pinTheme: PinTheme(
            activeColor: Pallet.gradient1,
            selectedColor: Pallet.gradient2,
            inactiveColor: Colors.white,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(height: 20),
        CustomElevatedButton(
          text: "verify",
          onPress: () {
            if (otpController.text.length != 6) {
              showSnackBarText("Field not be empty!");
            } else {
              verifyOTP(otpController.text).then((value) {
                if (value == true) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ));
                }
              });
            }
          },
        )
      ],
    );
  }

  Widget circle(double size) {
    return Container(
      height: screenHeight / size,
      width: screenHeight / size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
    );
  }
}
