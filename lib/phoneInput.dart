import 'package:chat_app/Homescreen.dart';
import 'package:chat_app/models/phone_number.dart';
import 'package:chat_app/models/phone_number_entity.dart';
import 'package:chat_app/otp_verification.dart';
import 'package:chat_app/service/fire_storage_service.dart';
import 'package:chat_app/service/isar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_app/models/phone_number_entity.dart';


class PhoneInput extends StatelessWidget {
  const PhoneInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 32, 47),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _PhoneInput(),
        ),
      ),
    );
  }
}

class _PhoneInput extends StatefulWidget {
  const _PhoneInput({Key? key}) : super(key: key);

  @override
  State<_PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<_PhoneInput> {
  TextEditingController phoneNumberController = TextEditingController();
  String? _verificationCode;
  String selectedCountryCode = '+84';
  String phoneNumber = '';

  get _auth => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 760,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 1,
                top: 11,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              const Positioned(
                left: 55,
                top: 210,
                child: SizedBox(
                  width: 280,
                  child: Text(
                    'Enter Your Phone Number',
                    style: TextStyle(
                      color: Color(0xFF0F1828),
                      fontSize: 24,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 25,
                right: 25,
                top: 240,
                child: SizedBox(
                  child: Text(
                    'Please confirm your country code and enter your phone number',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0F1828),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 350,
                left: 5,
                right: 10,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 50,
                      child: DropdownButtonFormField<String>(
                        items: ['+1', '+44', '+61', '+81', '+84']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCountryCode = newValue!;
                          });
                        },
                        value: selectedCountryCode,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFE7DFDF),
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 50,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            fillColor: const Color(0xFFE5DBDB),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintStyle: const TextStyle(
                              height: 0.7,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              phoneNumber = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 40,
                right: 40,
                top: 650,
                child: InkWell(
                  onTap: _verifyPhone,
                  onTap: () async {
                  final isarService = IsarService();

                  final newPhone = PhoneNumberEntity(
                    phoneNumber: phoneNumberController.text,
                  );

                  final result = await isarService.createPhoneNumber(newPhone);

                  if (result) {
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }
                  }

                  try {
                    final fireStorageService = FireStorageService();
                    final newPhone = PhoneNumber(
                      phone: phoneNumberController.text,
                    );
                    await fireStorageService.createPhoneNumber(newPhone);
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }
                  } catch (e) {
                    print("404 not found");
                  }
                },
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 18,
                      bottom: 20,
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
                child:  InkWell(
                  onTap: loginWihOTP,
                  child: Container(
                    color: Colors.orange,
                    height: 40,
                    width: 100,
                  ),
                ),
                ),
              ),
            ],
          ),
        ),
      ],
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
              loginWihOTP();
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
            print(" verficationID: $verficationID");
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
            print(" verficationID: $verificationID");
          });
        },
        timeout: Duration(seconds: 120),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
  void loginWihOTP() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
          verificationId: _verificationCode!, smsCode: '123456'))
          .then((value) async {
        if (value.user != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}