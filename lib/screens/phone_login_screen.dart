import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'verification_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  final int? mode;
  // mode 0: Login
  // mode 1: Register

  const PhoneLoginScreen({super.key, this.mode});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  String? selectedCountry;
  String? selectedCountryCode;
  final GlobalKey _countryPickerKey = GlobalKey();

  final Map<String, Map<String, dynamic>> countries = {
    'Afghanistan': {
      'code': '+93',
      'flag': '🇦🇫',
    },
    'Albania': {
      'code': '+355',
      'flag': '🇦🇱',
    },
    'Algeria': {
      'code': '+213',
      'flag': '🇩🇿',
    },
    'Indonesia': {
      'code': '+62',
      'flag': '🇮🇩',
    },
    // Add more countries as needed
  };

  void _showCountryPicker() {
    final RenderBox button =
        _countryPickerKey.currentContext!.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = 300.0;
    final menuLeft = (screenWidth - menuWidth) / 2;

    showMenu(
      context: context,
      color: const Color(0xFF2C2C2C),
      constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),
      position: RelativeRect.fromLTRB(
        menuLeft,
        buttonPosition.dy + button.size.height,
        menuLeft,
        buttonPosition.dy + button.size.height,
      ),
      items: countries.entries.map((entry) {
        return PopupMenuItem<String>(
          value: entry.key,
          child: Row(
            children: [
              Text(entry.value['flag'] as String),
              const SizedBox(width: 8),
              Text(
                entry.key,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                entry.value['code'] as String,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
    ).then((selectedValue) {
      if (selectedValue != null) {
        setState(() {
          selectedCountry = selectedValue;
          selectedCountryCode = countries[selectedValue]!['code'] as String;
        });
      }
    });
  }

  final TextEditingController _phoneController = TextEditingController();

  void _handleNext() async {
    if (selectedCountryCode != null && _phoneController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(
            mode: widget.mode,
            countryCode: selectedCountryCode!,
            phoneNumber: _phoneController.text,
          ),
        ),
      );
    } else {
      // Tampilkan pesan error jika input tidak lengkap
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Mohon lengkapi data negara dan nomor telepon')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: const Color(0xFF1F1F1F),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF7E85FF),
                  ),
                  child: const Icon(
                    Icons.telegram,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sign in to Telegram',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please confirm your country code\nand enter your phone number.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF7E85FF),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    key: _countryPickerKey,
                    onTap: _showCountryPicker,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedCountry == null
                              ? 'Country'
                              : '${countries[selectedCountry]!["flag"]} $selectedCountry',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 12),
                Container(
                  width: 300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        selectedCountryCode ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7E85FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: _handleNext,
                    child: const Text(
                      'NEXT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'LOG IN BY QR CODE',
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
      },
    );
  }
}
