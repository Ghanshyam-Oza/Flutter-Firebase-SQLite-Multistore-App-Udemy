import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multistore_supplier/minor_screens/edit_store.dart';
import 'package:multistore_supplier/models/product_model.dart';
import 'package:multistore_supplier/widgets/appbar_title.dart';
import 'package:multistore_supplier/widgets/my_snackbar.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitStoreScreen extends StatefulWidget {
  final String supplierId;
  const VisitStoreScreen({super.key, required this.supplierId});

  @override
  State<VisitStoreScreen> createState() => _VisitStoreScreenState();
}

class _VisitStoreScreenState extends State<VisitStoreScreen> {
  bool isFollowing = false;
  String? phoneNumber;

  contactViaWhatsapp() async {
    var countryCode = "+91";

    if (phoneNumber != null) {
      try {
        Uri url =
            Uri.parse("whatsapp://send?phone=${countryCode + phoneNumber!}");
        if (await canLaunchUrl(url)) {
          launchUrl(url);
        } else {
          Future.delayed(const Duration(microseconds: 100)).whenComplete(() {
            MySnackBar.showSnackBar(
                context: context,
                content: "Can't open whatsapp. Please try again later");
          });
        }
      } catch (err) {
        Future.delayed(const Duration(microseconds: 100)).whenComplete(() {
          MySnackBar.showSnackBar(
              context: context,
              content: "Something went wrong. Please try again later");
        });
      }
    } else {
      Future.delayed(const Duration(microseconds: 100)).whenComplete(() {
        MySnackBar.showSnackBar(
            context: context,
            content: "Supplier haven't provide their contact detail.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.supplierId)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.supplierId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          MySnackBar.showSnackBar(
              context: context, content: 'Something went wrong.');
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const AppBarTitle(label: "Visit Store"),
            ),
            body: const Center(
              child: Text(
                "This Supplier has no item yet.\nAdd some items first.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (data['phone'] != '') {
            phoneNumber = data['phone'];
          }

          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              toolbarHeight: 100,
              backgroundColor: Colors.yellow.shade300,
              title: Padding(
                padding: const EdgeInsets.only(left: 10, right: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(149, 0, 0, 0),
                              width: 3),
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.network(
                          data['storelogo'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(data['storename']),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: data['sid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditStore(data: data)));
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Edit",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.edit,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isFollowing = !isFollowing;
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      isFollowing ? "Following" : "Follow",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: productsStream,
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
                      "This category has no item yet.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return StaggeredGridView.countBuilder(
                  itemCount: snapshot.data!.docs.length,
                  crossAxisCount: 2,
                  itemBuilder: (context, index) {
                    return ProductModel(product: snapshot.data!.docs[index]);
                  },
                  staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                contactViaWhatsapp();
              },
              child: const Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
                size: 32,
              ),
            ),
          );
        }

        return const Material(
          child: Center(
            child: CircularProgressIndicator(color: Colors.yellow),
          ),
        );
      },
    );
  }
}
