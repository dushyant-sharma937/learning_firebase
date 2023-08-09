import 'package:flutter/material.dart';
import 'package:learning_firebase/screens/email_auth/login_screen.dart';
import 'package:learning_firebase/screens/phone_auth/sign_in_phone_screen.dart';
import 'package:learning_firebase/widgets/custom_button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  void phoneScreen() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SignInWithPhone()));
  }

  void emailScreen() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const LoginScreenEmailAuth()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Firebase Tutorial"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomButton(onPressed: phoneScreen, text: "Phone"),
              const SizedBox(height: 15),
              CustomButton(onPressed: emailScreen, text: "Email"),
            ],
          ),
        ),
      ),
    );
  }
}
