import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multistore_supplier/providers/auth_repo.dart';
import 'package:multistore_supplier/widgets/appbar_title.dart';
import 'package:multistore_supplier/widgets/my_snackbar.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String oldPwd = '';
  String newPwd = '';
  String confirmPwd = '';
  bool isOldPwdCorrect = true;
  bool? isConfirmPwdMatched;
  bool isProcessing = false;

  onSaveChanges() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      FocusManager.instance.primaryFocus?.unfocus();

      isOldPwdCorrect = await AuthRepo.checkOldPassword(
          FirebaseAuth.instance.currentUser!.email, oldPwd);

      if (confirmPwd == newPwd) {
        isConfirmPwdMatched = true;
      } else {
        isConfirmPwdMatched = false;
      }

      setState(() {});

      if (isOldPwdCorrect && isConfirmPwdMatched!) {
        setState(() {
          isProcessing = true;
        });
        AuthRepo.updateUserPassword(newPwd).whenComplete(() {
          MySnackBar.showSnackBar(
              context: context,
              content: "Your Password is Successfully Updated.");
          Future.delayed(const Duration(seconds: 3)).whenComplete(() {
            formKey.currentState!.reset();
            Navigator.pop(context);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(label: "Change Password"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                const Text(
                  "To Change your password. Please fill in the form below, and click on Save Changes",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Old Password',
                      hintText: 'Enter your old password',
                      errorText: isOldPwdCorrect != true
                          ? "Old password is not correct"
                          : null,
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 4),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length > 12 ||
                        value.trim().length < 6) {
                      return 'Password length must be between 6 to 12 characters';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    setState(() {
                      oldPwd = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Enter your new password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 4),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length > 12 ||
                        value.trim().length < 6) {
                      return 'Password length must be between 6 to 12 characters';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    setState(() {
                      newPwd = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Enter your new password again',
                      errorText: isConfirmPwdMatched != true &&
                              isConfirmPwdMatched != null
                          ? 'Confirm Password not matched.'
                          : null,
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 4),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter confirm password';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    confirmPwd = newValue!;
                  },
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  color: Colors.yellow,
                  onPressed: isProcessing == true ? null : onSaveChanges,
                  child: isProcessing == true
                      ? const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: CircularProgressIndicator(),
                        )
                      : const Text("Save Changes"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
