import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/minor_screens/address_book.dart';
import 'package:multi_store/widgets/appbar_title.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:multi_store/widgets/my_snackbar.dart';
import 'package:uuid/uuid.dart';

class AddAddressScreen extends StatefulWidget {
  final dynamic customer;
  final String? sourcePage;
  const AddAddressScreen({super.key, required this.customer, this.sourcePage});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
  String firstName = '';
  String lastName = '';
  String phone = '';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  addNewAddress() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if ((countryValue.isNotEmpty &&
              stateValue.isNotEmpty &&
              cityValue.isNotEmpty) &&
          (countryValue != 'Choose Country' &&
              stateValue != 'Choose State' &&
              cityValue != 'Choose City')) {
        try {
          var custSnapshot = await FirebaseFirestore.instance
              .collection('customers')
              .doc(widget.customer['cid'])
              .get();
          var snapshot = await FirebaseFirestore.instance
              .collection('customers')
              .doc(widget.customer['cid'])
              .collection('addresses')
              .get();

          var addressid = const Uuid().v4();
          FirebaseFirestore.instance
              .collection('customers')
              .doc(widget.customer['cid'])
              .collection('addresses')
              .doc(addressid)
              .set(
            {
              'addressid': addressid,
              'firstname': firstName,
              'lastname': lastName,
              'phone': phone,
              'country': countryValue,
              'state': stateValue,
              'city': cityValue,
              'default': snapshot.size == 0 || custSnapshot['address'] == ''
                  ? true
                  : false,
            },
          );
          if (snapshot.size == 0 || custSnapshot['address'] == '') {
            FirebaseFirestore.instance.runTransaction(
              (transaction) async {
                DocumentReference documentReference = FirebaseFirestore.instance
                    .collection("customers")
                    .doc(widget.customer['cid']);

                transaction.update(documentReference, {
                  'address': "$cityValue, $stateValue, $countryValue",
                  'phone': phone,
                });
              },
            );
          }

          Future.delayed(const Duration(microseconds: 100)).whenComplete(
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressBookScreen(
                  customer: widget.customer,
                  sourcePage: widget.sourcePage,
                  isFromAddAdress: true,
                ),
              ),
            ),
          );
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.sourcePage);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarTitle(label: 'Add Address'),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
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
                        firstName = newValue!;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
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
                        lastName = newValue!;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
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
                        phone = newValue!;
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
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
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                color: Colors.yellow,
                onPressed: addNewAddress,
                child: const Text("Add New Address"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension Validator on String {
  bool isValidName() {
    return RegExp(r'^[a-zA-Z ]{2,}$').hasMatch(this);
  }

  bool isValidPhoneNumber() {
    return RegExp(r'^[1-9][0-9]{9}$').hasMatch(this);
  }
}
