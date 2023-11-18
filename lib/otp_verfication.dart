import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OTPVerificationWidget extends StatelessWidget {
  final String verificationId;
  final String phoneNumber;
  final String inputPhoneNumber;

  OTPVerificationWidget({
    required this.verificationId,
    required this.phoneNumber,
    required this.inputPhoneNumber,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 32, 47),
      body: SafeArea(
        child: SingleChildScrollView(
          child: VerificationLight(
            phoneNumber: inputPhoneNumber,
          ),
        ),
      ),
    );
  }

}

class VerificationLight extends StatelessWidget {
  final String phoneNumber;

  const VerificationLight({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 759,
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
                left: 58,
                top: 169,
                child: Container(
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Enter Code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0F1828),
                          fontSize: 24,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 18),
                      SizedBox(
                        width: 261,
                        child: Text(
                          'We have sent you an SMS with the code ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0F1828),
                            fontSize: 14,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w400,
                            height: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 30,
                top: 303,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: OTPInputField(
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 60,
                      height: 60,
                      child: OTPInputField(),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 60,
                      height: 60,
                      child: OTPInputField(),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 60,
                      height: 60,
                      child: OTPInputField(),
                    ),
                  ],
                ),
              )


            ],
          ),
        ),
      ],
    );
  }
}

class OTPInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFECECEC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}



