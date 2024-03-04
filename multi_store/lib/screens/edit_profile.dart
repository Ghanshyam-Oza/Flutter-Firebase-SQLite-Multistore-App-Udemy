import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store/widgets/appbar_title.dart';
import 'package:multi_store/widgets/my_snackbar.dart';
import 'package:uuid/uuid.dart';

class EditProfile extends StatefulWidget {
  final dynamic data;
  const EditProfile({super.key, required this.data});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? profileImage;
  String custName = '';
  String addrFirstName = '';
  String addrLastName = '';
  String addrPhone = '';
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
  String defaultAddrId = '';
  bool isProcessing = false;
  late String custProfileImagePath;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("customers")
        .doc(widget.data['cid'])
        .collection("addresses")
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        for (final doc in querySnapshot.docs) {
          if (doc['default'] == true) {
            setState(() {
              addrFirstName = doc['firstname'];
              addrLastName = doc['lastname'];
              addrPhone = doc['phone'];
              countryValue = doc['country'];
              stateValue = doc['state'];
              cityValue = doc['city'];
              defaultAddrId = doc['addressid'];
            });
          }
        }
      },
    );
  }

  void pickProfileImage() async {
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
          profileImage = File(image.path);
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

  Future uploadProfileImage() async {
    if (profileImage != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref('customer-images/${widget.data['email']}.jpg');
        await ref.putFile(File(profileImage!.path));
        custProfileImagePath = await ref.getDownloadURL();
      } catch (err) {
        Future.delayed(const Duration(microseconds: 100)).whenComplete(() =>
            MySnackBar.showSnackBar(
                context: context,
                content: 'Something went wrong. Please Try again later.'));
      }
    } else {
      custProfileImagePath = widget.data['profileimage'];
    }
  }

  editCustomerData() async {
    if ((countryValue.isNotEmpty &&
            stateValue.isNotEmpty &&
            cityValue.isNotEmpty) &&
        (countryValue != 'Choose Country' &&
            stateValue != 'Choose State' &&
            cityValue != 'Choose City')) {
      try {
        String addressid;
        if (defaultAddrId == '') {
          addressid = const Uuid().v4();
          FirebaseFirestore.instance
              .collection('customers')
              .doc(widget.data['cid'])
              .collection('addresses')
              .doc(addressid)
              .set(
            {
              'addressid': addressid,
              'firstname': addrFirstName,
              'lastname': addrLastName,
              'phone': addrPhone,
              'country': countryValue,
              'state': stateValue,
              'city': cityValue,
              'default': true,
            },
          ).whenComplete(() => Navigator.pop(context));
        } else {
          addressid = defaultAddrId;
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentReference documentReference = FirebaseFirestore.instance
                .collection("customers")
                .doc(widget.data['cid'])
                .collection("addresses")
                .doc(addressid);
            transaction.update(documentReference, {
              'firstname': addrFirstName,
              'lastname': addrLastName,
              'phone': addrPhone,
              'country': countryValue,
              'state': stateValue,
              'city': cityValue,
            });
          });
        }
        FirebaseFirestore.instance.runTransaction(
          (transaction) async {
            DocumentReference documentReference2 = FirebaseFirestore.instance
                .collection("customers")
                .doc(widget.data['cid']);

            transaction.update(documentReference2, {
              'name': custName,
              'profileimage': custProfileImagePath,
              'address': "$cityValue, $stateValue, $countryValue",
              'phone': addrPhone,
            });
          },
        ).whenComplete(() => Navigator.pop(context));
      } catch (err) {
        Future.delayed(const Duration(microseconds: 100)).whenComplete(
          () => MySnackBar.showSnackBar(
              context: context,
              content: 'Something went wrong. Please Try again later.'),
        );
      }
    } else {
      MySnackBar.showSnackBar(
          context: context, content: 'Please Set Your Location.');
      setState(() {
        isProcessing = false;
      });
    }
  }

  updateChanges() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        isProcessing = true;
      });

      uploadProfileImage().whenComplete(() async => editCustomerData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(label: "Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        reverse: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
            child: Column(
              children: [
                const Text(
                  "Profile Image",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Stack(
                    children: [
                      profileImage == null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(widget.data['profileimage']),
                              radius: 70,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(profileImage!),
                              radius: 70,
                            ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            pickProfileImage();
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
                const SizedBox(height: 25),
                TextFormField(
                  initialValue: widget.data['name'],
                  decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    custName = newValue!;
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                ExpansionTile(
                  title: const Text("Add/Edit Address"),
                  children: [
                    const SizedBox(height: 5),
                    TextFormField(
                      initialValue: addrFirstName,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter your first name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 4),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.isValidName()) {
                          return 'Enter valid first name';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        addrFirstName = newValue!;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      initialValue: addrLastName,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        hintText: 'Enter your last name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 4),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.isValidName()) {
                          return 'Enter valid last name';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        addrLastName = newValue!;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      initialValue: addrPhone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 4),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.isValidPhoneNumber()) {
                          return 'Enter valid phone number';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        addrPhone = newValue!;
                      },
                    ),
                    const SizedBox(height: 14),
                    const Text(
                        "Note: If you don't select below address, It will set your current address (If any)."),
                    SelectState(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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

  bool isValidName() {
    return RegExp(r'^[a-zA-Z ]{2,}$').hasMatch(this);
  }
}
