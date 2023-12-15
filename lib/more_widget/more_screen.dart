import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/more_widget/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoreLight extends StatefulWidget {
  const MoreLight({Key? key}) : super(key: key);

  @override
  _MoreLightState createState() => _MoreLightState();
}

class _MoreLightState extends State<MoreLight> {
  late ChatUser user;

  @override
  void initState() {
    super.initState();
    try {
      APIs.getSelfInfo();
      setState(() {
        user = APIs.me;
      });
    } catch (e) {
      print('Lỗi khi lấy thông tin người dùng trong MoreLight: $e');
    }
  }

  Widget buildSettingRow(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w500,
            height: 0.12,
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF277AC7),
          size: 16,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem user có null hay không và xử lý tương ứng
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Phần trên cùng với chi tiết người dùng
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
                );
                // Xử lý khi nhấp vào chi tiết người dùng
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Chi tiết người dùng
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFECECEC),
                          ),
                          child: Center(
                            child: user.image != null
                                ? CachedNetworkImage(
                                    width: 60,
                                    height: 60,
                                    imageUrl: user.image!,
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) =>
                                        const CircleAvatar(
                                      child: Icon(CupertinoIcons.person),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                      child: Icon(CupertinoIcons.person),
                                    ),
                                  )
                                : const CircleAvatar(
                                    child: Icon(CupertinoIcons.person),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name ?? 'Tên người dùng',
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              user.email ?? '+62 1309 - 1710 - 1920',
                              style: const TextStyle(
                                color: Color(0xFFADB5BD),
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.about ?? '+62 1309 - 1710 - 1920',
                              style: const TextStyle(
                                color: Color(0xFF9399A1),
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Nút Logout
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Phần giữa với các thiết lập khác nhau
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    buildSettingRow('Tài khoản', Icons.account_circle),
                    const SizedBox(height: 30),
                    buildSettingRow('Chats', Icons.chat),
                    const SizedBox(height: 30),
                    buildSettingRow('Giao diện', Icons.color_lens),
                    const SizedBox(height: 30),
                    buildSettingRow('Thông báo', Icons.notifications),
                    const SizedBox(height: 30),
                    buildSettingRow('Quyền riêng tư', Icons.privacy_tip),
                    const SizedBox(height: 30),
                    buildSettingRow('Sử dụng dữ liệu', Icons.data_usage),
                    const SizedBox(height: 30),
                    buildSettingRow('Trợ giúp', Icons.help),
                    const SizedBox(height: 30),
                    buildSettingRow('Mời bạn bè', Icons.person_add),
                  ],
                ),
              ),
            ),
            // Phần dưới cùng với chỉ báo tiến trình
          ],
        ),
      ),
    );
  }
}
