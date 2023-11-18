import 'package:chat_app/otp_verfication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PhoneInput extends StatelessWidget {
  const PhoneInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 32, 47),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                child: GestureDetector(
                  onTap: () async {
                    await handlePhoneNumberVerification(context);
                  },
                  child: Container(
                    width: 327,
                    height: 55,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 11,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF002DE3),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFF7F7FC),
                          fontSize: 16,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Future<void> handlePhoneNumberVerification(BuildContext context) async {
    final fullPhoneNumber = selectedCountryCode + phoneNumber;
    print('Xác thực số điện thoại: $fullPhoneNumber');

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          print('Xác minh tự động thành công');
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Lỗi xác minh số điện thoại: ${e.message}');
          // TODO: Xử lý lỗi xác minh số điện thoại
        },
        codeSent: (String verificationId, int? resendToken) {
          navigateToOTPVerification(context, verificationId: verificationId, phoneNumber: fullPhoneNumber);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // TODO: Xử lý khi thời gian tự động lấy mã xác minh hết hạn
        },
        timeout: const Duration(seconds: 60), // Thời gian chờ để xác minh
      );
    } catch (e) {
      print('Lỗi gửi mã xác minh: $e');
      // TODO: Xử lý lỗi gửi mã xác minh
    }
  }

  void navigateToOTPVerification(BuildContext context,
      {required String verificationId, required String phoneNumber}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationWidget(
          verificationId: verificationId,
          phoneNumber: phoneNumber,
          inputPhoneNumber: phoneNumber, // Pass the input phone number to the OTP verification screen
        ),
      ),
    );
  }
}
