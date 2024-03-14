import 'package:flutter/material.dart';
import 'package:multistore_supplier/providers/auth_repo.dart';
import 'package:multistore_supplier/widgets/appbar_title.dart';
import 'package:multistore_supplier/widgets/my_snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String email;

  onSubmit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      try {
        AuthRepo.sendPasswordResetEmail(email).whenComplete(() =>
            MySnackBar.showSnackBar(
                context: context,
                content:
                    "Reset Password Email is sent. Please check your Inbox."));
      } catch (err) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(label: 'Forgot Password'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 30,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "To Reset Your Password,\nPlease Enter your email address \nand click on the button below.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 50),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your Email',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 4),
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.isEmailValid()) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  email = newValue!;
                },
              ),
              const SizedBox(height: 15),
              MaterialButton(
                color: Colors.yellow,
                onPressed: onSubmit,
                child: const Text("Send Reset Password Link"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isEmailValid() {
    return RegExp(
            r'^[a-zA-Z0-9]+[\.\_\-]*[a-zA-Z0-9]*[@][a-zA-Z]{2,}[\.][a-zA-Z]{2,5}$')
        .hasMatch(this);
  }
}
