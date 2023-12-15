import 'package:chat_app/home_screen.dart';
import 'package:chat_app/phoneInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyProfileScreen());
}

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
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
                        left: 1,
                        top: 11,
                        child: IconButton(
                          onPressed: () {
                            // Xử lý khi nút back được nhấn
                            // Điều hướng đến màn hình khác ở đây
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const InputPhoneNumber()), // Thay YourNextScreen() bằng màn hình bạn muốn chuyển đến
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 50,
                        top: 25,
                        child: SizedBox(
                          width: 280,
                          child: Text(
                            'Your Profile',
                            style: TextStyle(
                              color: Color(0xFF0F1828),
                              fontSize: 20,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 150,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF7F7FC),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 48,
                                color: Color(0xAFA7A7FF),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 220,
                        right: 147,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 270,
                        left: 20,
                        right: 20,
                        child: Container(
                          width: 237,
                          height: 36,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF7F7FC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: TextFormField(
                            // Sử dụng TextFormField thay vì Text
                            decoration: const InputDecoration(
                              border:
                                  InputBorder.none, // Ẩn viền của TextFormField
                              hintText: 'First Name (Required)',
                              hintStyle: TextStyle(
                                color: Color(0xFFADB5BD),
                                fontSize: 14,
                                fontFamily: 'Mulish',
                              ),
                            ),
                            style: const TextStyle(
                                // Kiểu chữ cho nội dung nhập
                                color: Colors.black, // Màu chữ
                                fontSize: 14,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                height: 0.7),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 320,
                        left: 20,
                        right: 20,
                        child: Container(
                          width: 237,
                          height: 36,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF7F7FC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: TextFormField(
                            // Sử dụng TextFormField thay vì Text
                            decoration: const InputDecoration(
                              border:
                                  InputBorder.none, // Ẩn viền của TextFormField
                              hintText: 'Last Name (Required)',
                              hintStyle: TextStyle(
                                color: Color(0xFFADB5BD),
                                fontSize: 14,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                height: 0.7,
                              ),
                            ),
                            style: const TextStyle(
                              // Kiểu chữ cho nội dung nhập
                              color: Colors.black, // Màu chữ
                              fontSize: 14,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        right: 40,
                        top: 670,
                        child: GestureDetector(
                          onTap: () {
                            // Xử lý khi nút "Save" được nhấn
                            // Thêm mã lệnh của bạn để lưu thông tin và thực hiện hành động cần thiết
                            // Sau đó, có thể sử dụng Navigator để chuyển đổi màn hình
                          },
                          child: Container(
                            width: 327,
                            height: 55,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 48, vertical: 11),
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
                                'Save',
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
              ),
            ),
          ],
        ),
      ],
    );
  }
}
