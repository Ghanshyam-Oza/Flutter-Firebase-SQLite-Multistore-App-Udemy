// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multi_store/providers/auth_repo.dart';
import 'package:multi_store/widgets/my_snackbar.dart';
import 'package:multi_store/widgets/repeated_divider.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  bool isPasswordVisible = false;
  bool isLogin = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool isSentEmailVerification = false;
  bool isDocExists = false;

  Future<bool> checkIfDocExists(docId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection("customers")
          .doc(docId)
          .get();
      return doc.exists;
    } catch (err) {
      return false;
    }
  }

  void onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLogin = true;
        });
        await AuthRepo.signInWithEmailAndPassword(email, password);
        await AuthRepo.updateUserData();
        if (await AuthRepo.checkEmailVerification()) {
          _formKey.currentState!.reset();
          setState(() {
            isLogin = false;
          });

          Navigator.pushReplacementNamed(context, "/customer_home");
        } else {
          MySnackBar.showSnackBar(
              context: context, content: "Please Check your Inbox");
          setState(() {
            isSentEmailVerification = true;
            isLogin = false;
          });
        }
      } on FirebaseAuthException catch (error) {
        setState(() {
          isLogin = false;
        });
        MySnackBar.showSnackBar(
            context: context, content: error.message.toString());
      } catch (error) {
        setState(() {
          isLogin = false;
        });
        MySnackBar.showSnackBar(
            context: context,
            content: 'Something went wrong. Please try again later.');
        print(error.toString());
      }
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() async {
      User user = FirebaseAuth.instance.currentUser!;
      isDocExists = await checkIfDocExists(user.uid);
      isDocExists == false
          ? await FirebaseFirestore.instance
              .collection('customers')
              .doc(user.uid)
              .set({
              'name': user.displayName,
              'email': user.email,
              'profileimage': user.photoURL,
              'phone': '',
              'address': '',
              'cid': user.uid
            }).whenComplete(() =>
                  Navigator.pushReplacementNamed(context, '/customer_home'))
          : Navigator.pushReplacementNamed(context, '/customer_home');
    });
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
                          "Log In",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 92, 92, 92),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/welcome_screen');
                          },
                          icon: const Icon(Icons.home_work),
                        ),
                      ],
                    ),
                  ),
                  isSentEmailVerification
                      ? ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification()
                                  .whenComplete(() => MySnackBar.showSnackBar(
                                      context: context,
                                      content:
                                          "Varification Email is Sent. Check your inbox."));
                            } catch (err) {
                              print(err);
                            }
                          },
                          child: const Text("Resend Email Varification"))
                      : const SizedBox(),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        children: [
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
                          TextButton(
                            onPressed: () {},
                            child: const Text("Forget Password ?"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have account? "),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/customer_signup");
                                },
                                child: const Text("Sign Up"),
                              ),
                            ],
                          ),
                          Material(
                            color: Colors.yellow.shade400,
                            borderRadius: BorderRadius.circular(10),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: onSubmit,
                              child: isLogin
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      "Log In",
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
                  divider(),
                  const SizedBox(height: 15),
                  googleLogInButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 80, child: RepeatedDivider()),
        Text("Or"),
        SizedBox(width: 80, child: RepeatedDivider()),
      ],
    );
  }

  googleLogInButton() {
    return SizedBox(
      width: 220,
      child: MaterialButton(
        color: const Color.fromARGB(255, 230, 230, 230),
        onPressed: signInWithGoogle,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.google,
              ),
              SizedBox(width: 10),
              Text(
                "Sign In With Google",
                style: TextStyle(fontSize: 15),
              )
            ],
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
