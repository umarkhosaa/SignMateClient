import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Components/SignInForm.dart';

class LoginScreen extends StatefulWidget {
  static String routeName="/loginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  SignInForm(),

    );
  }
}
