import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multistore_supplier/models/product_model.dart';
import 'package:multistore_supplier/widgets/my_snackbar.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class GallaryScreen extends StatefulWidget {
  const GallaryScreen({super.key, required this.category});
  final String category;

  @override
  State<GallaryScreen> createState() => _GallaryScreenState();
}

class _GallaryScreenState extends State<GallaryScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('mainCat', isEqualTo: widget.category)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
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
            return ProductModel(
              product: snapshot.data!.docs[index],
            );
          },
          staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
        );
      },
    );
  }
}
