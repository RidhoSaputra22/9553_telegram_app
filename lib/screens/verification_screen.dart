import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_clone/main.dart';
import 'package:telegram_clone/models/user.dart';
import 'package:telegram_clone/providers/auth.dart';
import 'package:telegram_clone/screens/web_layout.dart';
import 'web_home_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  final int? mode;
  // 0 = login, 1 = register

  const VerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
    this.mode,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _passwordController = TextEditingController();

  _login() async {
    final bool res =
        await AuthServices.login(widget.phoneNumber, _passwordController.text);

    if (res) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password Salah')),
      );
    }
  }

  _register() async {
    final bool res = await AuthServices.regist(
      User(
        id: null,
        name: widget.phoneNumber,
        email: widget.phoneNumber + '@gmail.com',
        hp: widget.phoneNumber,
        password: _passwordController.text,
      ),
    );

    if (res) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi Kesalahan')),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFDB65C),
                ),
                child: const Icon(
                  Icons.pets,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${widget.countryCode} ${widget.phoneNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We have sent you a message in Telegram\nwith the code.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth > 600
                        ? 300
                        : constraints.maxWidth * 0.9,
                    child: Column(
                      children: [
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          cursorColor: const Color(0xFF7E85FF),
                          controller: _passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2C2C2C),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            labelText: 'Code',
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: Color(0xFF7E85FF),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF7E85FF),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              widget.mode == 0 ? _login() : _register(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7E85FF),
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
