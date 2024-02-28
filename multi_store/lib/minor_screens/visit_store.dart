import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store/minor_screens/edit_store.dart';
import 'package:multi_store/models/product_model.dart';
import 'package:multi_store/widgets/my_snackbar.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class VisitStoreScreen extends StatefulWidget {
  final String supplierId;
  const VisitStoreScreen({super.key, required this.supplierId});

  @override
  State<VisitStoreScreen> createState() => _VisitStoreScreenState();
}

class _VisitStoreScreenState extends State<VisitStoreScreen> {
  bool isFollowing = false;
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
          return const Center(
            child: Text(
              "This Supplier has no item yet.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
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
              onPressed: () {},
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
