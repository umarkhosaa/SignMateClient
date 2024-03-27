import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Components/default_button.dart';
import '../../../utils/toast.dart';

import '../../main_screen.dart';


class VerifyCodeScreen extends StatefulWidget {
  static String routeName = "VerifyCode";
  final String VerificationId;

  const VerifyCodeScreen({Key? key, required this.VerificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verifyCodeController = TextEditingController();
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
                controller: verifyCodeController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '6 Digit Code',
                  labelText: "Enter Code",
                  labelStyle:const TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DefaultButton(
                text: "Verify",
                loading: loading,
                press: () async{
                  setState(() {
                    loading=true;
                  });
                  final credential= PhoneAuthProvider.credential
                    (verificationId: widget.VerificationId, smsCode: verifyCodeController.text.toString());
                  try{
                    await auth.signInWithCredential(credential);
                    Navigator.pushNamed(context, MainScreen.routeName);
                    setState(() {
                      loading=false;
                    });
                  }
                  catch(e){
                    utils().toastMessage(e.toString());
                  }
                  setState(() {
                    loading=false;
                  });
                },

              )
            ],
          ),
        ),
      ),
    );
  }
}
