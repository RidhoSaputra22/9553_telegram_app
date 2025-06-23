import 'package:flutter/material.dart';
import 'web_home_screen.dart';

class WebProfileScreen extends StatelessWidget {
  const WebProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF2C2C2C),
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              repeat: ImageRepeat.repeat,
              opacity: 0.5,
            ),
          ),
        ),
        // Profile content with slide animation
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          tween: Tween(begin: 420, end: 0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(value, 0),
              child: child,
            );
          },
          child: Container(
            width: 420,
            alignment: Alignment.topLeft,
            child: Scaffold(
              backgroundColor: const Color(0xFF1F1F1F),
              appBar: AppBar(
                backgroundColor: const Color(0xFF2C2C2C),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const WebHomeScreen(),
                      ),
                    );
                  },
                ),
                title: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: const Color(0xFF2C2C2C),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green,
                            child: Text(
                              'P',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'p',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(
                                'online',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: const Color(0xFF2C2C2C),
                      margin: const EdgeInsets.only(top: 8),
                      child: ListTile(
                        dense: false,
                        leading: const Icon(Icons.phone, color: Colors.white, size: 24),
                        title: const Text(
                          '+62 822 90228100',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: const Text(
                          'Phone',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ),
                    Container(
                      color: const Color(0xFF2C2C2C),
                      margin: const EdgeInsets.only(top: 1),
                      child: ListTile(
                        dense: true,
                        leading: const Icon(Icons.alternate_email, color: Colors.white, size: 22),
                        title: const Text(
                          'liliyy22',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        subtitle: const Text(
                          'Username',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // Menambah jarak setelah profil
                    Container(
                      color: const Color(0xFF2C2C2C),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Menambah padding vertikal
                        leading: const Icon(Icons.phone, color: Colors.white, size: 24),
                        title: const Text(
                          '+62 822 90228100',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        subtitle: const Text(
                          'Phone',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Container(
                      color: const Color(0xFF2C2C2C),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Menambah padding vertikal
                        leading: const Icon(Icons.alternate_email, color: Colors.white, size: 24),
                        title: const Text(
                          'liliyy22',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        subtitle: const Text(
                          'Username',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // Menambah jarak antar grup menu
                    Container(
                      color: const Color(0xFF2C2C2C),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
                            title: const Text(
                              'Notifications and Sounds',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onTap: () {},
                          ),
                          const SizedBox(height: 4),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: const Icon(Icons.lock_outline, color: Colors.white, size: 24),
                            title: const Text(
                              'Privacy and Security',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onTap: () {},
                          ),
                          const SizedBox(height: 4),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: const Icon(Icons.data_usage, color: Colors.white, size: 24),
                            title: const Text(
                              'Data and Storage',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onTap: () {},
                          ),
                          const SizedBox(height: 4),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: const Icon(Icons.chat_outlined, color: Colors.white, size: 24),
                            title: const Text(
                              'Chat Folders',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onTap: () {},
                          ),
                          const SizedBox(height: 4),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: const Icon(Icons.devices, color: Colors.white, size: 24),
                            title: const Text(
                              'Devices',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '6',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            onTap: () {},
                          ),
                          const SizedBox(height: 4),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: const Icon(Icons.language, color: Colors.white, size: 24),
                            title: const Text(
                              'Language',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            trailing: const Text(
                              'English',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      color: const Color(0xFF2C2C2C),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: const Icon(Icons.star_border, color: Colors.white, size: 24),
                            title: const Text(
                              'Telegram Premium',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onTap: () {},
                          ),
                          const SizedBox(height: 4),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: const Icon(Icons.card_giftcard, color: Colors.white, size: 24),
                            title: Row(
                              children: [
                                const Text(
                                  'Premium Gifting',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
