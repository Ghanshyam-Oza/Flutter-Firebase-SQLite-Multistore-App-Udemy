import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_store/minor_screens/full_screen_product_view.dart';
import 'package:multi_store/minor_screens/visit_store.dart';
import 'package:multi_store/models/product_model.dart';
import 'package:multi_store/providers/cart_provider.dart';
import 'package:multi_store/providers/wish_list_provider.dart';
import 'package:multi_store/screens/cart.dart';
import 'package:multi_store/widgets/my_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:collection/collection.dart';
import 'package:expandable/expandable.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic products;
  const ProductDetailsScreen({super.key, required this.products});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  double avgRating = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAvgRating();
  }

  void getAvgRating() {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance
        .collection('products')
        .doc(widget.products['productid'])
        .collection('reviews')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        avgRating += element['rate'];
      });
      setState(() {
        avgRating = avgRating != 0 ? avgRating / value.docs.length : 0;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('mainCat', isEqualTo: widget.products['mainCat'])
        .where('subCat', isEqualTo: widget.products['subCat'])
        .snapshots();
    final Stream<QuerySnapshot> reviewStream = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.products['productid'])
        .collection('reviews')
        .snapshots();
    final Stream<QuerySnapshot> reviewStreamLimited = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.products['productid'])
        .collection('reviews')
        .limit(2)
        .snapshots();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenProductView(
                          imageList: widget.products['productimages'],
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Swiper(
                          pagination: SwiperPagination.fraction,
                          itemBuilder: (context, index) {
                            return Image(
                              image: NetworkImage(
                                  widget.products['productimages'][index]),
                            );
                          },
                          itemCount: widget.products['productimages'].length,
                        ),
                      ),
                      Positioned(
                        child: CircleAvatar(
                          // backgroundColor: Colors.yellow.shade300,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          // backgroundColor: Colors.yellow.shade300,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.share),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    widget.products['productname'],
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "USD ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widget.products['discount'] == 0
                            ? Text(
                                widget.products['price'].toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                widget.products['price'].toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                        const SizedBox(width: 5),
                        widget.products['discount'] == 0
                            ? const SizedBox()
                            : Text(
                                ((1 - widget.products['discount'] / 100) *
                                        widget.products['price'])
                                    .toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        context
                                    .read<WishList>()
                                    .getWishListItems
                                    .firstWhereOrNull((item) =>
                                        item.documentId ==
                                        widget.products['productid']) !=
                                null
                            ? context
                                .read<WishList>()
                                .removeThis(widget.products['productid'])
                            : context.read<WishList>().addWishListItem(
                                widget.products['productname'],
                                widget.products['discount'] != 0
                                    ? ((1 - widget.products['discount'] / 100) *
                                        widget.products['price'])
                                    : widget.products['price'],
                                1,
                                widget.products['instock'],
                                widget.products['productimages'],
                                widget.products['productid'],
                                widget.products['sid']);
                      },
                      icon: context
                                  .watch<WishList>()
                                  .getWishListItems
                                  .firstWhereOrNull((item) =>
                                      item.documentId ==
                                      widget.products['productid']) !=
                              null
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            )
                          : const Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.red,
                              size: 30,
                            ),
                    ),
                  ],
                ),
                widget.products['instock'] == 0.0
                    ? const Text(
                        "This product is out of stock. ",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 18,
                        ),
                      )
                    : Text(
                        "${widget.products['instock']} pieces available in stock. ",
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 18,
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Product Description",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.products['productdesc'],
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                reviews(reviewStreamLimited, reviewStream),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Similar Products",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: productsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      Future.delayed(Duration.zero, () async {
                        MySnackBar.showSnackBar(
                            context: context, content: 'Something went wrong');
                      });
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
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      crossAxisCount: 2,
                      itemBuilder: (context, index) {
                        return ProductModel(
                            product: snapshot.data!.docs[index]);
                      },
                      staggeredTileBuilder: (context) =>
                          const StaggeredTile.fit(1),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VisitStoreScreen(
                                supplierId: widget.products['sid'])));
                  },
                  icon: const Icon(Icons.store),
                ),
                const SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(
                          isBackButton: true,
                        ),
                      ),
                    );
                  },
                  icon: Badge(
                    isLabelVisible:
                        context.watch<Cart>().getItems.isEmpty ? false : true,
                    backgroundColor: Colors.yellow,
                    label: Text(
                      context.watch<Cart>().getItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
              ],
            ),
            Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.55,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(25)),
              child: MaterialButton(
                onPressed: () {
                  widget.products['instock'] == 0
                      ? MySnackBar.showSnackBar(
                          context: context,
                          content: "This item is out of stock.")
                      : context.read<Cart>().getItems.firstWhereOrNull(
                                  (product) =>
                                      widget.products['productid'] ==
                                      product.documentId) !=
                              null
                          ? MySnackBar.showSnackBar(
                              context: context,
                              content: "Item is already in cart.")
                          : context.read<Cart>().addItem(
                                widget.products['productname'],
                                widget.products['discount'] != 0
                                    ? ((1 - widget.products['discount'] / 100) *
                                        widget.products['price'])
                                    : widget.products['price'],
                                1,
                                widget.products['instock'],
                                widget.products['productimages'],
                                widget.products['productid'],
                                widget.products['sid'],
                              );
                },
                child: context.read<Cart>().getItems.firstWhereOrNull(
                            (product) =>
                                widget.products['productid'] ==
                                product.documentId) !=
                        null
                    ? const Text(
                        "ADDED TO CART",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    : const Text(
                        "ADD TO CART",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget reviews(var reviewStreamLimited, var reviewStream) {
    return Stack(
      children: [
        Positioned(
            top: 8,
            right: 40,
            child: Text(
              "Average Ratings: ${avgRating.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 16),
            )),
        ExpandablePanel(
          header: const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Text(
              "Reviews",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          collapsed: reviewsAll(reviewStreamLimited),
          expanded: reviewsAll(reviewStream),
        ),
      ],
    );
  }

  Widget reviewsAll(var reviewStream) {
    return StreamBuilder<QuerySnapshot>(
      stream: reviewStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
        if (snapshot2.hasError) {
          MySnackBar.showSnackBar(
              context: context, content: 'Something went wrong');
        }

        if (snapshot2.connectionState == ConnectionState.waiting ||
            isLoading == true) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.yellow,
            ),
          );
        }

        if (snapshot2.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Center(
              child: Text(
                "There is not any review for this item.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapshot2.data!.docs[index]['profileimage'])),
              title: Text(snapshot2.data!.docs[index]['name']),
              subtitle: Text(snapshot2.data!.docs[index]['comment']),
              trailing: SizedBox(
                width: 55,
                child: Row(
                  children: [
                    Text(
                      snapshot2.data!.docs[index]['rate'].toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(Icons.star, color: Colors.amber),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
