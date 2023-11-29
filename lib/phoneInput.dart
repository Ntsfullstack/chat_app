
import 'package:chat_app/otp_verification.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';

class InputPhoneNumber extends StatefulWidget {
  const InputPhoneNumber({Key? key}) : super(key: key);

  @override
  State<InputPhoneNumber> createState() => _InputPhoneNumberState();
}

class _InputPhoneNumberState extends State<InputPhoneNumber> {
  TextEditingController phoneNumberController = TextEditingController();
  String? _verificationCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  child: SvgPicture.asset(
                    "assets/vectors/ic_arrow_left.svg",
                  ),
                ),
              ),
              const SizedBox(height: 98),
              const Center(
                child: Text(
                  "Enter Your Phone Number",
                  style: TextStyle(
                    color: Color(0xFF0F1828),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 40, vertical: 1),
                  child: Text(
                    "Please confirm your country code and enter your phone number",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1828),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7FC),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: TextFormField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                              color: Color(0xFFADB5BD),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 150),
              InkWell(
                onTap: _verifyPhone,
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                  ),
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFF002ED3),
                  ),
                  child: const Center(
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
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

  _verifyPhone() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+84${phoneNumberController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print('Phone number verification successful');
              // TODO: Navigate to the next screen or perform any necessary action
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verificationID, int? resendToken) {
          setState(() {
            _verificationCode = verificationID;
            print("Verification ID: $verificationID");
          });

          if (_verificationCode != null) {
            // Pass the verification code and phone number to OTPVerificationWidget
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerificationWidget(
                  verificationCode: _verificationCode!,
                  phoneNumber: phoneNumberController.text, verificationId: _verificationCode!,

                ),
              ),
            );
          } else {
            // Handle the case where verificationCode is null if needed
            print("Verification code is null");
          }
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
            print("Verification ID: $verificationID");
          });
        },
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

}
