import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/minor_screens/add_address.dart';
import 'package:multi_store/models/address_book_model.dart';
import 'package:multi_store/widgets/appbar_title.dart';
import 'package:multi_store/widgets/my_snackbar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class AddressBookScreen extends StatelessWidget {
  final dynamic customer;
  final String? sourcePage;
  final bool isFromAddAdress;
  const AddressBookScreen({
    super.key,
    required this.customer,
    this.sourcePage,
    required this.isFromAddAdress,
  });

  @override
  Widget build(BuildContext context) {
    print(sourcePage);
    print(isFromAddAdress);
    ProgressDialog progress = ProgressDialog(
      context: context,
    );
    void showProgress() async {
      progress.show(
        msg: "Please Wait...",
        progressBgColor: Colors.transparent,
        backgroundColor: Colors.white,
      );
      for (int i = 0; i <= 100; i++) {
        progress.update(value: i);
        i++;
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    void removeProgress() {
      progress.close(delay: 2000);
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (isFromAddAdress) {
              if (sourcePage == 'Profile') {
                Navigator.pop(context);
              }
              if (sourcePage == 'PlaceOrder') {
                Navigator.popUntil(context, ModalRoute.withName('PlaceOrder'));
              }
            }
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const AppBarTitle(label: 'Address Book'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("customers")
                  .doc(customer['cid'])
                  .collection("addresses")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  MySnackBar.showSnackBar(
                      context: context, content: 'Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.yellow,
                    ),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "You have not set your address.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var addr = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: () {
                          showProgress();
                          for (final address in snapshot.data!.docs) {
                            FirebaseFirestore.instance.runTransaction(
                              (transaction) async {
                                DocumentReference documentReference =
                                    address.reference;

                                transaction.update(
                                  documentReference,
                                  {
                                    'default': false,
                                  },
                                );
                              },
                            );
                          }
                          FirebaseFirestore.instance.runTransaction(
                            (transaction) async {
                              DocumentReference documentReference =
                                  addr.reference;

                              transaction.update(
                                documentReference,
                                {
                                  'default': true,
                                },
                              );

                              DocumentReference documentReference2 =
                                  FirebaseFirestore.instance
                                      .collection("customers")
                                      .doc(customer['cid']);

                              transaction.update(documentReference2, {
                                'address':
                                    "${addr['city']}, ${addr['state']}, ${addr['country']}",
                                'phone': addr['phone'],
                              });
                              removeProgress();
                            },
                          );
                        },
                        child: Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) async {
                            await FirebaseFirestore.instance.runTransaction(
                              (transaction) async {
                                DocumentReference docReference = addr.reference;

                                if (addr['default']) {
                                  DocumentReference customerdocumentReference2 =
                                      FirebaseFirestore.instance
                                          .collection("customers")
                                          .doc(customer['cid']);

                                  transaction
                                      .update(customerdocumentReference2, {
                                    'address': "",
                                    'phone': "",
                                  });
                                }
                                transaction.delete(docReference);
                              },
                            );
                          },
                          child: AddressBookModel(addr: addr),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: double.infinity,
            child: MaterialButton(
              color: Colors.yellow,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAddressScreen(
                      customer: customer,
                      sourcePage: sourcePage,
                    ),
                  ),
                );
              },
              child: const Text("Add New Address"),
            ),
          ),
        ],
      ),
    );
  }
}
