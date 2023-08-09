// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_firebase/screens/email_auth/login_screen.dart';
import 'package:learning_firebase/widgets/custom_button.dart';
import 'package:learning_firebase/widgets/snackbar.dart';

class SignUpScreenEmailAuth extends StatefulWidget {
  const SignUpScreenEmailAuth({super.key});

  @override
  State<SignUpScreenEmailAuth> createState() => _SignUpScreenEmailAuthState();
}

class _SignUpScreenEmailAuthState extends State<SignUpScreenEmailAuth> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();

  final TextEditingController _cpassController = TextEditingController();

  void createAccount() async {
    String email = _emailController.text.trim();
    String password = _passController.text.trim();
    String cpassword = _cpassController.text.trim();

    if (email == "" || password == "" || cpassword == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar("Please fill all details"));
    } else if (!email.contains('@') || !email.contains('.com')) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar("Enter a valid email address"));
    } else if (password.length < 7) {
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar("Password should be at least 7 characters long"));
    } else if (password != cpassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar("Password do not match"));
    } else {
      // create a new account
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginScreenEmailAuth()));
        print("User created");
      } on FirebaseAuthException catch (error) {
        print(error.code.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(error.message.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 15),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Email Address",
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passController,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _cpassController,
              decoration: const InputDecoration(
                hintText: "Confirm Password",
              ),
            ),
            const SizedBox(height: 15),
            CustomButton(text: "Create Account", onPressed: createAccount),
          ],
        )),
      ),
    );
  }
}
