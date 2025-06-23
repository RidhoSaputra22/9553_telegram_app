import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_clone/screens/web_home_screen.dart';
import 'phone_login_screen.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({super.key});

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('id') != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const WebHomeScreen()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: 'https://t.me/login',
                version: QrVersions.auto,
                size: 200.0,
                embeddedImage: const AssetImage('assets/telegram_logo.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(40, 40),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Log in to Telegram by QR Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '1. Open Telegram on your phone',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              '2. Go to Settings > Devices > Link Desktop Device',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              '3. Point your phone at this screen to confirm login',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhoneLoginScreen(mode: 0),
                  ),
                );
              },
              child: const Text(
                'LOG IN BY PHONE NUMBER',
                style: TextStyle(
                  color: Color(0xFF7E85FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhoneLoginScreen(mode: 1),
                  ),
                );
              },
              child: const Text(
                'REGISTER BY PHONE NUMBER',
                style: TextStyle(
                  color: Color(0xFF7E85FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: const Text(
                'LANJUTKAN DALAM BAHASA INDONESIA',
                style: TextStyle(
                  color: Color(0xFF7E85FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
