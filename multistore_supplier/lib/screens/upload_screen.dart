// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multistore_supplier/utilities/categ_list.dart';
import 'package:multistore_supplier/widgets/my_snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  late double price;
  late int quantity;
  int discount = 0;
  late String productName;
  late String productDesc;
  List<XFile>? productImages = [];
  List<String> productUrlList = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String mainCatValue = 'Select Category';
  String subCatValue = 'Select Sub-Category';
  List<String> subCatList = [];
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    void onUpload() async {
      FocusManager.instance.primaryFocus?.unfocus();

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        if (productImages!.isNotEmpty) {
          try {
            setState(() {
              isUploading = true;
            });
            for (final image in productImages!) {
              final ref = FirebaseStorage.instance
                  .ref('products/${path.basename(image.path)}');
              await ref.putFile(File(image.path));
              var url = await ref.getDownloadURL();
              productUrlList.add(url);
            }

            var productId = const Uuid().v4();
            CollectionReference collectionReference =
                FirebaseFirestore.instance.collection("products");
            await collectionReference.doc(productId).set({
              'productid': productId,
              'mainCat': mainCatValue,
              'subCat': subCatValue,
              'price': price,
              'instock': quantity,
              'productname': productName,
              'productdesc': productDesc,
              'productimages': productUrlList,
              'sid': FirebaseAuth.instance.currentUser!.uid,
              'discount': discount,
            });

            setState(() {
              isUploading = false;
              productImages = [];
              mainCatValue = 'Select Category';
              subCatValue = 'Select Sub-Category';
              subCatList = [];
              productUrlList = [];
            });
          } catch (error) {
            setState(() {
              isUploading = false;
            });
            MySnackBar.showSnackBar(
                context: context,
                content: "Something went wrong. Please try again later.");
          }

          _formKey.currentState!.reset();
        } else {
          MySnackBar.showSnackBar(
              context: context, content: "Please Pick Images First.");
        }
      }
    }

    void pickImages() async {
      FocusManager.instance.primaryFocus?.unfocus();
      try {
        final pickedImages = await ImagePicker()
            .pickMultiImage(maxHeight: 300, maxWidth: 300, imageQuality: 95);
        setState(() {
          productImages = pickedImages;
        });
      } catch (error) {
        MySnackBar.showSnackBar(
            context: context, content: 'Something went wrong.');
      }
    }

    Widget previewImages() {
      if (productImages!.isNotEmpty) {
        return ListView.builder(
            itemCount: productImages!.length,
            itemBuilder: (context, index) {
              return Image.file(
                File(productImages![index].path),
                fit: BoxFit.contain,
              );
            });
      } else {
        return const Center(child: Text("No images picked yet."));
      }
    }

    void onSelectMainCategory(String? value) {
      if (value == 'men') {
        subCatList = men;
      } else if (value == 'women') {
        subCatList = women;
      } else if (value == 'shoes') {
        subCatList = shoes;
      } else if (value == 'electronics') {
        subCatList = electronics;
      } else if (value == 'accessories') {
        subCatList = accessories;
      } else if (value == 'bags') {
        subCatList = bags;
      } else if (value == 'home & garden') {
        subCatList = home;
      } else if (value == 'kids') {
        subCatList = kids;
      } else if (value == 'beauty') {
        subCatList = beauty;
      }
      setState(() {
        mainCatValue = value!;
        subCatValue = 'Select Sub-Category';
      });
    }

    return Scaffold(
      body: SafeArea(
        child: isUploading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                ),
              )
            : SingleChildScrollView(
                reverse: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 250, 235, 93),
                          ),
                          child: productImages != null
                              ? previewImages()
                              : const Center(
                                  child: Text("No images picked yet.")),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Select Main Category:  ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButtonFormField(
                                    value: mainCatValue,
                                    items: maincateg
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(value),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      onSelectMainCategory(value);
                                    },
                                    validator: (value) {
                                      if (value == 'Select Category') {
                                        return 'Select Main Category';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Select Sub Category:  ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButtonFormField(
                                    value: subCatValue,
                                    disabledHint: const Text("Select Category"),
                                    menuMaxHeight: 400,
                                    items: subCatList
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(value),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        subCatValue = value!;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == 'Select Sub-Category') {
                                        return 'Select Sub-Category';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Price',
                                      hintText: '\$ 00.00',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Enter Price';
                                      } else if (double.parse(value) == 0) {
                                        return 'Enter Valid Price';
                                      } else if (!value.isValidPrice()) {
                                        return 'Enter Valid Price';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      price = double.parse(newValue!);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Discount %',
                                      hintText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    maxLength: 2,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value != null &&
                                          value.isNotEmpty &&
                                          !value.isValidDiscount()) {
                                        return 'Enter Valid Discount';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      if (newValue != null &&
                                          newValue.isNotEmpty) {
                                        discount = int.parse(newValue);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Quantity',
                                      hintText: '',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Enter Quantity';
                                      } else if (!value.isValidQuantity()) {
                                        return 'Enter Valid Quantity';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      quantity = int.parse(newValue!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              maxLength: 100,
                              maxLines: 2,
                              decoration: InputDecoration(
                                labelText: 'Product Name',
                                hintText: 'Enter your product name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter Product Name';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                productName = newValue!;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              maxLength: 800,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: 'Product Description',
                                hintText: 'Enter your product description',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter Product Description';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                productDesc = newValue!;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 253, 237, 99),
            onPressed: isUploading
                ? null
                : productImages!.isEmpty
                    ? pickImages
                    : () {
                        setState(() {
                          productImages = [];
                        });
                      },
            child: productImages!.isEmpty
                ? const Icon(
                    Icons.photo_library,
                    size: 30,
                  )
                : const Icon(
                    Icons.delete_forever,
                    size: 30,
                  ),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 253, 237, 99),
            onPressed: isUploading ? null : onUpload,
            child: const Icon(
              Icons.upload,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

extension Validator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }

  bool isValidDiscount() {
    return RegExp(r'^[1-9][0-9]?$').hasMatch(this);
  }

  bool isValidPrice() {
    return RegExp(r'^(([1-9][0-9]*[/.]*)||([0][/.]))([0-9]{1,2})$')
        .hasMatch(this);
  }
}
