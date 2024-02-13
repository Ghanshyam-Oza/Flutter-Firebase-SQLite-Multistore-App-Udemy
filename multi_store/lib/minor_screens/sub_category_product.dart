import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/models/product_model.dart';
import 'package:multi_store/widgets/my_snackbar.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SubCategoryProduct extends StatefulWidget {
  const SubCategoryProduct(
      {super.key, required this.cat, required this.subCat});
  final String cat;
  final String subCat;

  @override
  State<SubCategoryProduct> createState() => _SubCategoryProductState();
}

class _SubCategoryProductState extends State<SubCategoryProduct> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('mainCat',
            isEqualTo: widget.cat.toLowerCase() == 'home'
                ? 'home & garden'
                : widget.cat.toLowerCase())
        .where('subCat', isEqualTo: widget.subCat.toLowerCase())
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.subCat,
            style: const TextStyle(
              fontFamily: 'Acme',
              fontSize: 26,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                "This sub category has no item yet.",
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
    );
  }
}
