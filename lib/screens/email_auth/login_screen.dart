import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_firebase/screens/email_auth/signup_screen.dart';
import 'package:learning_firebase/screens/home_screen.dart';
import 'package:learning_firebase/widgets/custom_button.dart';

import '../../widgets/snackbar.dart';
import '../intro_screen.dart';

class LoginScreenEmailAuth extends StatefulWidget {
  const LoginScreenEmailAuth({super.key});

  @override
  State<LoginScreenEmailAuth> createState() => _LoginScreenEmailAuthState();
}

class _LoginScreenEmailAuthState extends State<LoginScreenEmailAuth> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void loginUser() async {
    String email = _emailController.text.trim();
    String password = _passController.text.trim();
    if (email == "" || password == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar("Please fill all details"));
    } else if (!email.contains('@') || !email.contains('.com')) {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar("Enter a valid email address"));
    } else if (password.length < 7) {
      ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar("Password should be at least 7 characters long"));
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print("Login successful");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } on FirebaseAuthException catch (error) {
        print(error.code.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(customSnackBar(error.message.toString()));
      }
    }
  }

  void introScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const IntroScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
              obscureText: true,
            ),
            const SizedBox(height: 15),
            CustomButton(
              text: "Login",
              onPressed: loginUser,
            ),
            const SizedBox(height: 7),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignUpScreenEmailAuth()));
              },
              child: const Text(
                "Create an account",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
