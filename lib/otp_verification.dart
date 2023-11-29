import 'package:chat_app/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/phoneInput.dart';

class OTPScreen extends StatelessWidget {
  final String verificationId;
  final String phoneNumber;

  const OTPScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: OTPVerificationWidget(
            verificationId: verificationId,
            phoneNumber: phoneNumber, verificationCode: '',
          ),
        ),
      ),
    );
  }
}

class OTPVerificationWidget extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OTPVerificationWidget({
    Key? key,
    required this.verificationId,
    required this.phoneNumber, required String verificationCode,
  }) : super(key: key);

  @override
  _OTPVerificationWidgetState createState() => _OTPVerificationWidgetState();
}

class _OTPVerificationWidgetState extends State<OTPVerificationWidget> {
  late String enteredOTP;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter Code',
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontSize: 24,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'We have sent you an SMS with the code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0F1828),
                  fontSize: 14,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              OTPInputFields(
                onSubmitted: (otp) {
                  setState(() {
                    enteredOTP = otp;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => loginWithOTP(context),
                child: const Text('Confirm'),
              ),
              SizedBox(height: 20,),
            const Text(
              'Dont have a code ?'' Resend Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0F1828),
                fontSize: 15,
                fontFamily: 'Mulish',


              ),
            )
            ],
          ),
        ),
      ),
    );
  }

  void loginWithOTP(BuildContext context) async {
    print("Verification ID: ${widget.verificationId}");
    print("Entered OTP: $enteredOTP");

    try {
      if (widget.verificationId != null && enteredOTP != null && enteredOTP.isNotEmpty) {
        final authCredential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: enteredOTP,
        );

        await FirebaseAuth.instance.signInWithCredential(authCredential).then((value) async {
          if (value.user != null) {
            // Navigate to the desired screen after successful login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyProfileScreen()),
            );
          }
        });
      } else {
        print("Error: verificationId or enteredOTP is null or empty");
        // Handle the case where either verificationId or enteredOTP is null or empty
      }
    } catch (e) {
      print("Error during OTP verification: $e");
      // Handle the specific error here, you can print it or show a specific message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to authenticate. Please try again."),
        ),
      );
    }
  }
}

class OTPInputFields extends StatelessWidget {
  final Function(String) onSubmitted;

  const OTPInputFields({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
            (index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: SizedBox(
              width: 43,
              height: 43,
              child: OTPInputField(onSubmitted: onSubmitted),
            ),
          ),
        ),
      ),
    );

  }
}

class OTPInputField extends StatelessWidget {
  final Function(String) onSubmitted;

  const OTPInputField({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFDCD4D4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (value.isNotEmpty) {
          onSubmitted(value);
          FocusScope.of(context).nextFocus();
        }
      },
    );
  }
}


