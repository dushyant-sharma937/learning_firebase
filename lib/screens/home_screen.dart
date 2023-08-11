import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_firebase/screens/intro_screen.dart';
import 'package:learning_firebase/widgets/custom_button.dart';
import 'package:learning_firebase/widgets/snackbar.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const IntroScreen()));
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? profilePic;
  double? progressvalue;
  bool isLoading = true;
  void saveUser() async {
    isLoading = true;
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();

    _nameController.clear();
    _emailController.clear();
    if (name != "" && email != "" && profilePic != null) {
      UploadTask uploadtask = FirebaseStorage.instance
          .ref()
          .child("ProfilePictures")
          .child(Uuid().v1())
          .putFile(profilePic!);

      StreamSubscription taskSubscription =
          uploadtask.snapshotEvents.listen((snapshot) {
        double percentage =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        setState(() {
          progressvalue = percentage;
        });
      });

      TaskSnapshot taskSnapshot = await uploadtask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      taskSubscription.cancel();

      Map<String, dynamic> userData = {
        "name": name,
        "email": email,
        "downloadUrl": downloadUrl,
      };
      await FirebaseFirestore.instance.collection("users").add(userData);
      print("New user added");
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar("Please add all the fields"));
    }
    setState(() {
      profilePic = null;
    });
    isLoading = false;
  }

  void deleteUser(String id) async {
    await FirebaseFirestore.instance.collection("users").doc(id).delete();
    print("User deleted successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () => logOut(),
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                XFile? selectedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (selectedImage != null) {
                  File? convertedFile = File(selectedImage.path);
                  setState(() {
                    profilePic = convertedFile;
                  });
                  print("Image is selected");
                } else {
                  print("No image is selected");
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 30,
                backgroundImage:
                    (profilePic != null) ? FileImage(profilePic!) : null,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Name",
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Email address",
              ),
            ),
            const SizedBox(height: 15),
            CustomButton(onPressed: saveUser, text: "Submit"),
            const SizedBox(height: 15),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("users").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return (isLoading == false)
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> userMap =
                                        snapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            userMap["downloadUrl"]),
                                      ),
                                      title: Text(userMap["name"]),
                                      subtitle: Text(userMap["email"]),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => deleteUser(
                                            snapshot.data!.docs[index].id),
                                      ),
                                    );
                                  }),
                            )
                          : CircularProgressIndicator();
                    } else {
                      return Text("No data found");
                    }
                  } else {
                    return Text("No internet");
                  }
                })
          ],
        ),
      )),
    );
  }
}
