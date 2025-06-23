import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/web_layout.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram Clone',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF527DA3),
        scaffoldBackgroundColor: const Color(0xFF1F1F1F),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF527DA3),
          secondary: const Color(0xFF527DA3),
          surface: const Color(0xFF2C2C2C),
          background: const Color(0xFF1F1F1F),
        ),
      ),
      theme: ThemeData(
        primaryColor: const Color(0xFF527DA3),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF527DA3)),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return const WebLayout();
        }
        return const LoginScreen();
      },
    );
  }
}
