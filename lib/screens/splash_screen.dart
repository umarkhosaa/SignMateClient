import 'package:flutter/material.dart';
import 'package:signmate/screens/Authentication/Sign_In/login_Screen.dart';
import 'package:signmate/screens/main_screen.dart';

import 'home/home_screen.dart';

void main() {
  runApp(const SignMateApp());
}

class SignMateApp extends StatelessWidget {
  const SignMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SignMate',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Simulate an asynchronous task (e.g., loading data)
  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 4)); // Simulating a delay

    // Add your logic to load initial data here

    // For now, let's navigate to the home screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData(); // Initiate the loading process
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/images/Welcome Page.jpg', // Replace with your loading image
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}