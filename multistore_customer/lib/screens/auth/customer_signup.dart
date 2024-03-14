// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multistore_customer/providers/auth_repo.dart';
import 'package:multistore_customer/widgets/my_snackbar.dart';

class CustomerSignUpScreen extends StatefulWidget {
  const CustomerSignUpScreen({super.key});

  @override
  State<CustomerSignUpScreen> createState() => _CustomerSignUpScreenState();
}

class _CustomerSignUpScreenState extends State<CustomerSignUpScreen> {
  bool isPasswordVisible = false;
  bool isSignUp = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String fullName;
  late String email;
  late String password;
  File? userImage;
  late String profileImage;

  void onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      if (userImage == null) {
        MySnackBar.showSnackBar(
            context: context, content: 'Please pick an image first.');
        return;
      }
      _formKey.currentState!.save();
      try {
        setState(() {
          isSignUp = true;
        });
        await AuthRepo.signUpWithEmailAndPassword(email, password);

        AuthRepo.sendEmailVerification();

        final ref = FirebaseStorage.instance.ref('customer-images/$email.jpg');

        await ref.putFile(File(userImage!.path));
        profileImage = await ref.getDownloadURL();

        final _uid = AuthRepo.uid;

        AuthRepo.updateUserName(fullName);
        AuthRepo.updateProfileImage(profileImage);

        await FirebaseFirestore.instance.collection('customers').doc(_uid).set({
          'name': fullName,
          'email': email,
          'profileimage': profileImage,
          'phone': '',
          'address': '',
          'cid': _uid
        });
        _formKey.currentState!.reset();
        setState(() {
          userImage = null;
          isSignUp = false;
        });

        Navigator.pushReplacementNamed(context, "/customer_login");
      } on FirebaseAuthException catch (error) {
        setState(() {
          isSignUp = false;
        });
        MySnackBar.showSnackBar(
            context: context, content: error.message.toString());
      } catch (error) {
        setState(() {
          isSignUp = false;
        });
        MySnackBar.showSnackBar(
            context: context,
            content: 'Something went wrong. Please try again later.');
        print(error.toString());
      }
    }
  }

  void _pickImage(String src) async {
    try {
      ImagePicker picker = ImagePicker();
      XFile? image;
      if (src == 'camera') {
        image = await picker.pickImage(
            source: ImageSource.camera,
            maxHeight: 300,
            maxWidth: 300,
            imageQuality: 95);
      } else {
        image = await picker.pickImage(
            source: ImageSource.gallery,
            maxHeight: 300,
            maxWidth: 300,
            imageQuality: 95);
      }

      if (image == null) return;

      setState(
        () {
          userImage = File(image!.path);
        },
      );
    } catch (error) {
      MySnackBar.showSnackBar(context: context, content: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 255, 239, 98),
      // backgroundColor: Colors.grey,
      backgroundColor: const Color.fromARGB(255, 210, 210, 210),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width * 0.84,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 92, 92, 92),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/customer_home", (route) => false);
                          },
                          icon: const Icon(Icons.home_work),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            const Color.fromARGB(255, 252, 236, 90),
                        backgroundImage:
                            userImage == null ? null : FileImage(userImage!),
                      ),
                      Column(
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 238, 87),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                _pickImage("camera");
                              },
                              icon: const Icon(Icons.camera),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 238, 87),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                            ),
                            child: IconButton(
                              onPressed: () {
                                _pickImage("gallery");
                              },
                              icon: const Icon(Icons.photo),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              hintText: 'Enter your full name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !(value.isValidName())) {
                                return 'Please enter valid full name';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              fullName = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'Enter your email address',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !(value.isValidEmail())) {
                                return 'Please enter valid Email';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              email = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                icon: Icon(isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.length < 6 ||
                                  value.length > 12) {
                                return 'Password should be 6 to 12 Characters long';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              password = newValue!;
                            },
                          ),
                          Row(
                            children: [
                              const Text("Already have an account? "),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/customer_login');
                                },
                                child: const Text("Log in"),
                              ),
                            ],
                          ),
                          Material(
                            color: Colors.yellow.shade400,
                            borderRadius: BorderRadius.circular(10),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: onSubmit,
                              child: isSignUp
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension Validator on String {
  bool isValidEmail() {
    return RegExp(
            r'^[a-zA-Z0-9]+[\.\_\-]*[a-zA-Z0-9]*[@][a-zA-Z]{2,}[\.][a-zA-Z]{2,5}$')
        .hasMatch(this);
  }

  bool isValidName() {
    return RegExp(r'^[a-zA-Z ]{2,}$').hasMatch(this);
  }
}
