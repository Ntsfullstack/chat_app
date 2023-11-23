import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OTPVerificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 32, 47),
      body: SafeArea(
        child: SingleChildScrollView(
          child: VerificationLight(),
        ),
      ),
    );
  }
}

class VerificationLight extends StatelessWidget {
  const VerificationLight({Key? key}) : super(key: key);

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
                left: 20,
                top: 303,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 60,
                      child: OTPInputField(),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 40,
                      height: 60,
                      child: OTPInputField(),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 40,
                      height: 60,
                      child: OTPInputField(),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 40,
                      height: 60,
                      child: OTPInputField(),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 40,
                      height: 60,
                      child: OTPInputField(),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 40,
                      height: 60,
                      child: OTPInputField(),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              // Add the confirmation button
              Positioned(
                right: MediaQuery.of(context).size.width * 0.4,
                top: MediaQuery.of(context).size.height * 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    // Call the function to handle OTP confirmation
                  },
                  child: Text('Confirm'),
                ),
              ),


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
    return SizedBox(
      width: 32,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFABA1A1),
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


