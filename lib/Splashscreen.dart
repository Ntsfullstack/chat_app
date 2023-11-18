import 'package:chat_app/phoneInput.dart';
import 'package:flutter/material.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: WalkthroughLight(),
          ),
        ),
      ),
    );
  }
}

class WalkthroughLight extends StatelessWidget {
  const WalkthroughLight({Key? key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity, // Sử dụng chiều rộng toàn màn hình
          height: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              const Positioned(
                left: 53,
                top: 448,
                child: SizedBox(
                  width: 280,
                  child: Text(
                    'Connect easily with your family and friends over countries',
                    textAlign: TextAlign.center,
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
              Positioned(
                left: 62,
                top: 135,
                child: SizedBox(
                  width: 262,
                  height: 271,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 43,
                        child: SizedBox(
                          width: 149.98,
                          height: 228,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 3.89,
                                top: 0,
                                child: Container(
                                  width: 117.46,
                                  height: 117.46,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFCDE1FD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                              ),
                              // Thêm ảnh vào đây
                              const Positioned(
                                left: 3.89, // Điều chỉnh vị trí của ảnh
                                top: 0, // Điều chỉnh vị trí của ảnh
                                child: Image(
                                  image: AssetImage('assets/layer.svg'),
                                ), // Thay đổi đường dẫn đến hình ảnh của bạn
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 152,
                        top: 0,
                        child: SizedBox(
                          width: 110,
                          height: 100,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 10,
                                top: 0,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFCDE1FD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                ),
                              ),
                              // Thêm ảnh vào đây
                              const Positioned(
                                left: 10, // Điều chỉnh vị trí của ảnh
                                top: 0, // Điều chỉnh vị trí của ảnh
                                child: Image(
                                  image: AssetImage('assets/man.svg'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: 120,
                top: 664,
                child: Text(
                  'Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0F1828),
                    fontSize: 14,
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w600,
                    height: 0.12,
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                top: 706,
                child: GestureDetector(
                  onTap: () {
                    // Xử lý khi click vào button
                    // Chuyển sang widget khác ở đây
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PhoneInput()),
                    );
                  },
                  child: Container(
                    width: 327,
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
                        'Start Messaging',
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
}
