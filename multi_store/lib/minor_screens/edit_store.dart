import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/widgets/appbar_title.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store/widgets/my_snackbar.dart';

class EditStore extends StatefulWidget {
  final dynamic data;

  const EditStore({super.key, required this.data});

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  File? logoImage;
  File? coverImage;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late String phoneNumber;
  late String storeName;
  late String storeLogoPath;
  late String coverImagePath;
  bool isProcessing = false;

  void pickLogoImage() async {
    try {
      final picker = ImagePicker();

      var image = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );

      if (image != null) {
        setState(() {
          logoImage = File(image.path);
        });
      }
    } catch (e) {
      Future.delayed(const Duration(microseconds: 100)).then(
        (value) => MySnackBar.showSnackBar(
            context: context,
            content: 'Something went wrong.. Can\'t select Image.'),
      );
    }
  }

  void pickCoverImage() async {
    try {
      final picker = ImagePicker();

      var image = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );

      if (image != null) {
        setState(() {
          coverImage = File(image.path);
        });
      }
    } catch (e) {
      Future.delayed(const Duration(microseconds: 100)).then(
        (value) => MySnackBar.showSnackBar(
            context: context,
            content: 'Something went wrong.. Can\'t select Image.'),
      );
    }
  }

  Future uploadStoreLogo() async {
    if (logoImage != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref('supplier-images/${widget.data['email']}.jpg');
        await ref.putFile(File(logoImage!.path));
        storeLogoPath = await ref.getDownloadURL();
      } catch (err) {
        Future.delayed(const Duration(microseconds: 100)).whenComplete(() =>
            MySnackBar.showSnackBar(
                context: context,
                content: 'Something went wrong. Please Try again later.'));
      }
    } else {
      storeLogoPath = widget.data['storelogo'];
    }
  }

  Future uploadStoreCoverImage() async {
    if (coverImage != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref('supplier-images/${widget.data['email']}.jpg-cover');
        await ref.putFile(File(coverImage!.path));
        coverImagePath = await ref.getDownloadURL();
      } catch (err) {
        Future.delayed(const Duration(microseconds: 100)).whenComplete(() =>
            MySnackBar.showSnackBar(
                context: context,
                content: 'Something went wrong. Please Try again later.'));
      }
    } else {
      coverImagePath = widget.data['coverimage'];
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storename': storeName,
        'phone': phoneNumber,
        'storelogo': storeLogoPath,
        'coverimage': coverImagePath,
      });
    }).whenComplete(() => Navigator.pop(context));
  }

  updateChanges() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      setState(() {
        isProcessing = true;
      });
      uploadStoreLogo().whenComplete(() async =>
          await uploadStoreCoverImage().whenComplete(() => editStoreData()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(label: 'Edit Store'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                const Text(
                  "Store Logo",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Center(
                  child: Stack(
                    children: [
                      logoImage == null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(widget.data['storelogo']),
                              radius: 70,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(logoImage!),
                              radius: 70,
                            ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            pickLogoImage();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                const Text(
                  "Cover Image",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Center(
                  child: Stack(
                    children: [
                      coverImage == null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(widget.data['coverimage']),
                              radius: 70,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(coverImage!),
                              radius: 70,
                            ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            pickCoverImage();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  initialValue: widget.data['storename'],
                  decoration: InputDecoration(
                      labelText: 'Store Name',
                      hintText: 'Enter Store name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter store logo';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    storeName = newValue!;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: widget.data['phone'],
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter Phone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty || !value.isValidPhoneNumber()) {
                      return 'Please enter valid phone number';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    phoneNumber = newValue!;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Colors.yellow,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    isProcessing == true
                        ? const MaterialButton(
                            color: Colors.yellow,
                            onPressed: null,
                            child: CircularProgressIndicator(
                              color: Colors.yellow,
                            ),
                          )
                        : MaterialButton(
                            color: Colors.yellow,
                            onPressed: updateChanges,
                            child: const Text('Update Detail'),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension PhoneNumber on String {
  bool isValidPhoneNumber() {
    return RegExp(r'^[1-9][0-9]{9}$').hasMatch(this);
  }
}
