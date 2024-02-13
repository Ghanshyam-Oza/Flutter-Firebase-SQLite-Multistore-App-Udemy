import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/minor_screens/product_details.dart';
import 'package:multi_store/providers/wish_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ProductModel extends StatelessWidget {
  const ProductModel({super.key, required this.product});
  final dynamic product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              products: product,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Container(
                  constraints:
                      const BoxConstraints(minHeight: 100, maxWidth: 350),
                  child: Image(
                    image: NetworkImage(product['productimages'][0]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['productname'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product['price'].toStringAsFixed(2) + (" \$"),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        product['sid'] == FirebaseAuth.instance.currentUser!.uid
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  context
                                              .read<WishList>()
                                              .getWishListItems
                                              .firstWhereOrNull((item) =>
                                                  item.documentId ==
                                                  product['productid']) !=
                                          null
                                      ? context
                                          .read<WishList>()
                                          .removeThis(product['productid'])
                                      : context
                                          .read<WishList>()
                                          .addWishListItem(
                                              product['productname'],
                                              product['price'],
                                              1,
                                              product['instock'],
                                              product['productimages'],
                                              product['productid'],
                                              product['sid']);
                                },
                                icon: context
                                            .watch<WishList>()
                                            .getWishListItems
                                            .firstWhereOrNull((item) =>
                                                item.documentId ==
                                                product['productid']) !=
                                        null
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 25,
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
