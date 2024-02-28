// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store/utilities/categ_list.dart';
import 'package:multi_store/widgets/my_snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class EditProductScreen extends StatefulWidget {
  final dynamic product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late double price;
  late int quantity;
  int discount = 0;
  late String productName;
  late String productDesc;
  List<XFile>? productImages = [];
  List<dynamic> productUrlList = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> subCatList = [];
  bool isUploading = false;
  String subCatValue = 'Select Sub-Category';
  String mainCatValue = 'Select Category';

  @override
  void initState() {
    super.initState();
    mainCatValue = widget.product['mainCat'];
    if (mainCatValue == 'men') {
      subCatList = men;
    } else if (mainCatValue == 'women') {
      subCatList = women;
    } else if (mainCatValue == 'shoes') {
      subCatList = shoes;
    } else if (mainCatValue == 'electronics') {
      subCatList = electronics;
    } else if (mainCatValue == 'accessories') {
      subCatList = accessories;
    } else if (mainCatValue == 'bags') {
      subCatList = bags;
    } else if (mainCatValue == 'home & garden') {
      subCatList = home;
    } else if (mainCatValue == 'kids') {
      subCatList = kids;
    } else if (mainCatValue == 'beauty') {
      subCatList = beauty;
    }
    subCatValue = widget.product['subCat'];
  }

  @override
  Widget build(BuildContext context) {
    void onSaveChanges() async {
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

            setState(() {
              isUploading = false;
              // productImages = [];
              // mainCatValue = 'Select Category';
              // subCatValue = 'Select Sub-Category';
              // subCatList = [];
              // productUrlList = [];
            });
          } catch (error) {
            setState(() {
              isUploading = false;
            });
            MySnackBar.showSnackBar(
                context: context,
                content: "Something went wrong. Please try again later.");
          }
        } else {
          productUrlList = widget.product['productimages'];
        }

        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentReference documentReference = FirebaseFirestore.instance
              .collection('products')
              .doc(widget.product['productid']);

          transaction.update(documentReference, {
            'mainCat': mainCatValue,
            'subCat': subCatValue,
            'price': price,
            'discount': discount,
            'instock': quantity,
            'productname': productName,
            'productdesc': productDesc,
            'productimages': productUrlList,
          });
        }).whenComplete(() => Navigator.pop(context));
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

    Widget previewCurrentImages() {
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
        List<dynamic> currentImages = widget.product['productimages'];
        return ListView.builder(
          itemCount: currentImages.length,
          itemBuilder: (context, index) {
            return Image.network(currentImages[index]);
          },
        );
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

    deleteProduct() async {
      setState(() {
        isUploading = true;
      });
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('products')
            .doc(widget.product['productid']);

        transaction.delete(documentReference);
      }).whenComplete(() => Navigator.pop(context));
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
                      Stack(
                        children: [
                          Center(
                            child: Container(
                                clipBehavior: Clip.hardEdge,
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 250, 235, 93),
                                ),
                                child: previewCurrentImages()),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 135,
                            child: InkWell(
                              onTap: pickImages,
                              child: Container(
                                height: 30,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Edit",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.edit,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
                                    items:
                                        maincateg.map<DropdownMenuItem<String>>(
                                      (value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(value),
                                          ),
                                        );
                                      },
                                    ).toList(),
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
                                  "Select Sub Category: ",
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
                                    initialValue: widget.product['price']
                                        .toStringAsFixed(2),
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
                                    initialValue:
                                        widget.product['discount'].toString(),
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
                                      if (newValue != null) {
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
                                    initialValue:
                                        widget.product['instock'].toString(),
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
                              initialValue: widget.product['productname'],
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
                              initialValue: widget.product['productdesc'],
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MaterialButton(
                                  color: Colors.yellow,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                MaterialButton(
                                  color: Colors.yellow,
                                  onPressed: onSaveChanges,
                                  child: const Text("Save Changes"),
                                ),
                                MaterialButton(
                                  color: Colors.red,
                                  onPressed: deleteProduct,
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

extension Validator on String {
  bool isValidQuantity() {
    return RegExp(r'^[0-9]*$').hasMatch(this);
  }

  bool isValidDiscount() {
    return RegExp(r'^[0-9]*$').hasMatch(this);
  }

  bool isValidPrice() {
    return RegExp(r'^(([1-9][0-9]*[/.]*)||([0][/.]))([0-9]{1,2})$')
        .hasMatch(this);
  }
}
