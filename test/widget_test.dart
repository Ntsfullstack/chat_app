import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PhoneInput(),
      ),
    );
  }
}

class PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: MyHomePage(),
          ),
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
  String selectedCountryCode = '+1';
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 760,
          // ... your existing UI code
          child: Positioned(
            left: 40,
            right: 40,
            top: 650,
            child: GestureDetector(
              onTap: () async {
                if (phoneNumber.isNotEmpty) {
                  await handlePhoneNumberVerification();
                } else {
                  print('Phone number is empty');
                }
              },
              child: Container(
                width: 327,
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 11),
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
        ),
      ],
    );
  }

  Future<void> handlePhoneNumberVerification() async {
    codeSent(String verificationId, [int? forceResendingToken]) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OTPVerificationWidget(
            verificationId: verificationId,
          ),
        ),
      );
    }

    if (phoneNumber.isNotEmpty) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: selectedCountryCode + phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }
}

class OTPVerificationWidget extends StatefulWidget {
  final String verificationId;
  OTPVerificationWidget({required this.verificationId});

  @override
  _OTPVerificationWidgetState createState() => _OTPVerificationWidgetState();
}

class _OTPVerificationWidgetState extends State<OTPVerificationWidget> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Enter OTP Code',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter OTP',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final int smsCode = int.tryParse(otpController.text) ?? 0;
            try {
              await verifyOTP(widget.verificationId, smsCode);
            } catch (e) {
              print('Xác thực thất bại: $e');
            }
          },
          child: const Text('Verify OTP'),
        ),
      ],
    );
  }

  Future<void> verifyOTP(String verificationId, int smsCode) async {
    try {
      final AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode.toString(),
      );

      final UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      User? user = authResult.user;
    } catch (e) {
      print('Xác thực thất bại: $e');
    }
  }
}
