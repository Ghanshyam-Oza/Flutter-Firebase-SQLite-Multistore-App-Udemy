import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/minor_screens/product_details.dart';
import 'package:multi_store/widgets/my_snackbar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: CupertinoSearchTextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              searchInput = value;
            });
          },
        ),
      ),
      body: searchInput == ''
          ? const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  Text(" Search For Products."),
                ],
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  MySnackBar.showSnackBar(
                      context: context, content: 'Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Material(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.yellow,
                      ),
                    ),
                  );
                }

                var result = snapshot.data!.docs.where((element) =>
                    element['productname']
                        .toLowerCase()
                        .contains(searchInput.toLowerCase()));

                if (result.isEmpty) {
                  return const Center(
                    child: Text("No Products found. Search Anything else."),
                  );
                }

                return ListView(
                  children: result
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailsScreen(products: e)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Row(children: [
                                Image.network(e['productimages'][0]),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e['productname'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          e['productdesc'],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
    );
  }
}
