// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/minor_screens/forgot_password.dart';
import 'package:multi_store/providers/auth_repo.dart';
import 'package:multi_store/widgets/my_snackbar.dart';

class SupplierLoginScreen extends StatefulWidget {
  const SupplierLoginScreen({super.key});

  @override
  State<SupplierLoginScreen> createState() => _SupplierLoginScreenState();
}

class _SupplierLoginScreenState extends State<SupplierLoginScreen> {
  bool isPasswordVisible = false;
  bool isLogin = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool isSentEmailVerification = false;

  void onSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLogin = true;
        });

        AuthRepo.signInWithEmailAndPassword(email, password);
        await AuthRepo.updateUserData();
        if (await AuthRepo.checkEmailVerification()) {
          _formKey.currentState!.reset();
          setState(() {
            isLogin = false;
          });
          Navigator.pushReplacementNamed(context, "/supplier_home");
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
        print("ERROR:: ${error.toString()}");
      }
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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            child: const Text("Forget Password ?"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have account? "),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, "/supplier_signup");
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
