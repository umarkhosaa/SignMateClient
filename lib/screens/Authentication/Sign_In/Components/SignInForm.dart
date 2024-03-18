import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signmate/Components/gradient_button.dart';

import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../../Components/default_button.dart';
import '../../../../Components/social_card.dart';
import '../../../../Controllers/authenticationController.dart';
import '../../../main_screen.dart';
import '../../SignInWithPhone/SignInPhone.dart';
import '../../Sign_Up/signUp_screen.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var authenticationController = AuthenticationController.instanceAuth;

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    const SizedBox(
                      height: 160,
                    ),
                    Container(
                        height: 80,
                        margin: EdgeInsets.only(bottom: 40),
                        child: Image.asset(
                          'assets/images/logored.png',
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: const TextStyle(color: Colors.black),
                              labelText: "Email",
                              hintText: "Enter Your Email",
                              suffixIcon: Icon(Icons.mail, color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: const TextStyle(color: Colors.black),
                              labelText: "Password",
                              hintText: "Enter Your Password",
                              suffixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Password";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          DefaultButton(
                            text: 'Login',
                            loading: loading,
                            press: () {
                              if (_formKey.currentState!.validate()) {
                                authenticationController.login(
                                    emailController.text,
                                    passwordController.text);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not have an account ?',
                            style: TextStyle(
                              fontSize: 15,
                            )),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, SignUpScreen.routeName);
                          },
                          child: const Text(
                            ' Sign Up',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),

                    // SizedBox(
                    //   height: 20,
                    // ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 60),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.blue],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          GoogleAuthentication().signInWithGoogle(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/icons/google-icon.svg"),
                              SizedBox(width: 8,),
                              Text("Continue With Google",
                                  style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     // SocialCard(
                    //     //   icon: 'assets/icons/google-icon.svg',
                    //     //   press: () {
                    //     //     GoogleAuthentication().signInWithGoogle(context);
                    //     //
                    //     //
                    //     //   },
                    //     // ),
                    //     SocialCard(
                    //
                    //
                    //
                    //       icon: 'assets/icons/facebook-2.svg',
                    //       press: () {
                    //         FacebookAuthentication().loginWithFacebook(context);
                    //         },
                    //     ),
                    //     // SocialCard(
                    //     //   icon: 'assets/icons/twitter.svg',
                    //     //   press: () {},
                    //     // ),
                    //   ],
                    // )
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     SocialCard(
                    //       icon: 'assets/icons/google-icon.svg',
                    //       press: () {
                    //
                    //       },
                    //     ),
                    //     SocialCard(
                    //       icon: 'assets/icons/facebook-2.svg',
                    //       press: () {},
                    //     ),
                    //     SocialCard(
                    //       icon: 'assets/icons/twitter.svg',
                    //       press: () {},
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            )));
  }

  SignInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.accessToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }
}
