import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_firebase/screens/home_screen.dart';
import 'package:learning_firebase/widgets/snackbar.dart';

import '../../widgets/custom_button.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  void verifyOtp() async {
    String otpCode = _otpController.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otpCode);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(error.message.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 15),
            TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(
                hintText: "Enter 6-digit OTP",
                counterText: "",
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              autofocus: true,
            ),
            const SizedBox(height: 15),
            CustomButton(
              text: "Verify",
              onPressed: verifyOtp,
            ),
            const SizedBox(height: 7),
          ],
        )),
      ),
    );
  }
}
