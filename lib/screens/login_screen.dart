import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:telegram_clone/providers/auth.dart';
import 'package:telegram_clone/screens/home_screen.dart';
import 'package:telegram_clone/screens/phone_login_screen.dart';
import 'package:telegram_clone/screens/verification_screen.dart';
import 'package:telegram_clone/screens/web_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedCountry = '';
  String countryCode = '';
  String phoneNumber = '';
  bool showKeypad = false;

  _checkLogin() async {
    final String? id = await AuthServices.getUserId();
    if (id != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  void _addNumber(String number) {
    setState(() {
      phoneNumber += number;
    });
  }

  void _deleteNumber() {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      });
    }
  }

  Widget _buildKeypadButton(String number, [String? letters]) {
    return Expanded(
      child: TextButton(
        onPressed: () => _addNumber(number),
        child: Column(
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            if (letters != null)
              Text(
                letters,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome() async {
    if (countryCode.isNotEmpty && phoneNumber.isNotEmpty) {
      // TODO: implement Login
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerificationScreen(
                  phoneNumber: phoneNumber,
                  countryCode: countryCode,
                  mode: 0,
                )),
      );
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
      backgroundColor: const Color(0xFF1E2936),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    'Your phone number',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please confirm your country code\nand enter your phone number.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Country Selection
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        selectedCountry.isEmpty ? 'Country' : selectedCountry,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white70,
                      ),
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          countryListTheme: CountryListThemeData(
                            backgroundColor: const Color(0xFF1E2936),
                            textStyle: const TextStyle(color: Colors.white),
                            searchTextStyle:
                                const TextStyle(color: Colors.white),
                            bottomSheetHeight: 500,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          onSelect: (Country country) {
                            setState(() {
                              selectedCountry = country.name;
                              countryCode = country.phoneCode;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Phone Number Display
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showKeypad = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Text(
                              countryCode.isEmpty ? '+' : '+$countryCode',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              phoneNumber.isEmpty
                                  ? 'Phone number'
                                  : phoneNumber,
                              style: TextStyle(
                                color: phoneNumber.isEmpty
                                    ? Colors.grey
                                    : Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneLoginScreen(
                                    mode: 1,
                                  )));
                    },
                    child: const Text(
                      'Belum Pernah Login?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  if (showKeypad) ...[
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildKeypadButton('1'),
                              _buildKeypadButton('2', 'ABC'),
                              _buildKeypadButton('3', 'DEF'),
                            ],
                          ),
                          Row(
                            children: [
                              _buildKeypadButton('4', 'GHI'),
                              _buildKeypadButton('5', 'JKL'),
                              _buildKeypadButton('6', 'MNO'),
                            ],
                          ),
                          Row(
                            children: [
                              _buildKeypadButton('7', 'PQRS'),
                              _buildKeypadButton('8', 'TUV'),
                              _buildKeypadButton('9', 'WXYZ'),
                            ],
                          ),
                          Row(
                            children: [
                              Spacer(),
                              _buildKeypadButton('0', '+'),
                              Expanded(
                                child: TextButton(
                                  onPressed: _deleteNumber,
                                  child: const Icon(
                                    Icons.backspace_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Next Button
                    Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FloatingActionButton(
                          onPressed: _navigateToHome, // Ubah ini
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
