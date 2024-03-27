import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../../Components/default_button.dart';
import '../../../utils/toast.dart';
import 'VerifyCodeScreen.dart';

class SignInPhone extends StatefulWidget {
  static String routeName = "/PSignIn";
  const SignInPhone({Key? key}) : super(key: key);

  @override
  State<SignInPhone> createState() => _SignInPhoneState();
}

class _SignInPhoneState extends State<SignInPhone> {
  bool loading = false;
  final phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Container(
                  height: 80,
                  margin: EdgeInsets.only(bottom: 40),
                  child: Image.asset(
                    'assets/images/karaoke.png',
                  )),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+923096065117',
                  labelText: "Enter Your Phone Number",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DefaultButton(
                loading: loading,
                press: () {
                  setState(() {
                    loading=true;
                  });
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text,
                      verificationCompleted: (_) {
                        setState(() {
                          loading=false;
                        });
                      },
                      verificationFailed: (e) {
                        setState(() {
                          loading=false;
                        });
                        utils().toastMessage(e.toString());

                      },
                      codeSent: (String VerificationId, int? token) {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (VerifyCodeScreen(
                                      VerificationId: VerificationId,
                                    ))));
                        setState(() {
                          loading=false;
                        });
                      },

                      codeAutoRetrievalTimeout: (e) {

                        utils().toastMessage(e.toString());
                        setState(() {
                          loading=false;
                        });
                      });
                },
                text: "Continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
