import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Components/signUp_form.dart';

class SignUpScreen extends StatefulWidget {

  static String routeName = "/SignUpScreen";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignUpForm(),
    );
  }
}
