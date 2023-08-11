import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learning_firebase/screens/home_screen.dart';
import 'package:learning_firebase/screens/intro_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

  // FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Map<String, dynamic> newUserData = {
  //   "name": "Dushu Dushu",
  //   "email": "dushu@dushu.com",
  // };

  // await _firestore.collection("users").add(newUserData);
  // print("new user added");

  // await _firestore.collection("users").doc("1JUyoqDOjRNDeRQjJPiB").update({
  //   "email": "dushu-dushu@gmail.com",
  // });
  // print("New user updated");

  // await _firestore.collection("users").doc("new-id").set(newUserData);
  // print("New user added using new-id");

  // QuerySnapshot snapshot = await _firestore.collection("users").get();
  // for (var i in snapshot.docs) {
  //   print(i);
  //   print(i.data().toString());
  // }

  // DocumentSnapshot snapshot =
  //     await _firestore.collection("users").doc("new-id").get();
  // print(snapshot.data().toString());

  // await _firestore.collection("users").doc("new-id").delete();
  // print("new-id is deleted");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null)
          ? const HomeScreen()
          : const IntroScreen(),
    );
  }
}
