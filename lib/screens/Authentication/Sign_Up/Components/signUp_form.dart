import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../Components/default_button.dart';
import '../../../../Controllers/authenticationController.dart';
import '../../Sign_In/login_Screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final authenticationController = Get.find<AuthenticationController>();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    authenticationController.resetImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios_new, size: 23),
        title: const Text('Sign Up', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: isSaving
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildProfileImageEditButton(),
              const SizedBox(height: 30),
              _buildSignUpForm(),
              const SizedBox(height: 12),
              _buildSignInLink(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageEditButton() {
    return GestureDetector(
      onTap: () => authenticationController.chooseImageFromGallery(),
      child: Obx(() {
        var _image = authenticationController.profileImage;

        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: _image != null
                  ? FileImage(_image)
                  : AssetImage('assets/images/profile.png') as ImageProvider,
              backgroundColor: Colors.transparent,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(controller: userNameController, labelText: "User Name", hintText: "Enter Your Name", icon: Icons.person),
          const SizedBox(height: 12),
          _buildTextField(controller: emailController, labelText: "Email", hintText: "Enter Your Email", icon: Icons.email),
          const SizedBox(height: 12),
          _buildTextField(controller: passwordController, labelText: "Password", hintText: "Enter Your Password", icon: Icons.lock, obscureText: true),
          const SizedBox(height: 40),
          DefaultButton(text: 'Sign Up', press: _handleSignUp),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelText, required String hintText, required IconData icon, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $labelText' : null,
    );
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSaving = true;
      });

      try {
        // Show an error message if the user doesn't upload a profile image
        if (authenticationController.profileImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please upload a profile image'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        await authenticationController.createAccountForNewUser(
          authenticationController.profileImage!,
          userNameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } catch (e) {
        // Handle other exceptions
      } finally {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Widget _buildSignInLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?', style: TextStyle(fontSize: 15)),
        InkWell(
          onTap: () => Navigator.pushNamed(context, LoginScreen.routeName),
          child: const Text(' Login', style: TextStyle(fontSize: 18, color: Colors.deepOrange, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
