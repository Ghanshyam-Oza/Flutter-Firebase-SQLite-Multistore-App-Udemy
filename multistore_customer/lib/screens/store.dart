import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multistore_customer/minor_screens/visit_store.dart';
import 'package:multistore_customer/widgets/appbar_title.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade300,
        centerTitle: true,
        elevation: 0,
        title: const AppBarTitle(label: 'Store'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("suppliers").snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.hasData) {
            return GridView.builder(
              itemCount: snapshots.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitStoreScreen(
                          supplierId: snapshots.data!.docs[index]['sid'],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          const Icon(
                            Icons.store,
                            size: 150,
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Image.network(
                              snapshots.data!.docs[index]['storelogo'],
                              width: 110,
                              height: 48,
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
                      ),
                      Text(
                        snapshots.data!.docs[index]['storename'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text("No stores are available"),
          );
        },
      ),
    );
  }
}
