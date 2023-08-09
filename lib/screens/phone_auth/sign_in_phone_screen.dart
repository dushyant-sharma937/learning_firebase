import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_firebase/screens/intro_screen.dart';
import 'package:learning_firebase/screens/phone_auth/verify_otp_screen.dart';
import 'package:learning_firebase/widgets/snackbar.dart';

import '../../widgets/custom_button.dart';

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({super.key});

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  final TextEditingController _phoneController = TextEditingController();

  void introScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const IntroScreen()));
  }

  void sendOtp() async {
    String phone = _phoneController.text.trim();
    if (phone.length != 10) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar("Please enter a 10-digit phone number"));
    } else {
      phone = "+91${_phoneController.text.trim()}";

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        codeSent: (verificationId, resendToken) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VerifyOtpScreen(verificationId: verificationId)));
        },
        verificationCompleted: (credential) {},
        verificationFailed: (error) {
          customSnackBar(error.code.toString());
        },
        codeAutoRetrievalTimeout: (verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In With Phone"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.output_sharp),
            onPressed: introScreen,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 15),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: "Phone number",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            CustomButton(
              text: "Sign In",
              onPressed: sendOtp,
            ),
            const SizedBox(height: 7),
          ],
        )),
      ),
    );
  }
}
