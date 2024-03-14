import 'package:flutter/material.dart';
import 'package:multistore_customer/minor_screens/product_details.dart';
import 'package:multistore_customer/providers/product.dart';
import 'package:multistore_customer/providers/wish_list_provider.dart';
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
              product: product,
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
          child: Stack(
            children: [
              Column(
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
                            Row(
                              children: [
                                const Text(
                                  "\$ ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                                product['discount'] == 0
                                    ? Text(
                                        product['price'].toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      )
                                    : Text(
                                        product['price'].toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                const SizedBox(width: 5),
                                product['discount'] == 0
                                    ? const SizedBox()
                                    : Text(
                                        ((1 - product['discount'] / 100) *
                                                product['price'])
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
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
                                                product['productid']) !=
                                        null
                                    ? context
                                        .read<WishList>()
                                        .removeThis(product['productid'])
                                    : context.read<WishList>().addWishListItem(
                                        Product(
                                            documentId: product['productid'],
                                            name: product['productname'],
                                            price: product['discount'] != 0
                                                ? ((1 -
                                                        product['discount'] /
                                                            100) *
                                                    product['price'])
                                                : product['price'],
                                            orderedQuantity: 1,
                                            totalQuantity: product['instock'],
                                            imageUrl: product['productimages']
                                                [0],
                                            supplierId: product['sid']));
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
              product['discount'] != 0
                  ? Positioned(
                      top: 45,
                      left: 0,
                      child: Container(
                        height: 30,
                        width: 80,
                        decoration: const BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                bottomRight: Radius.circular(15))),
                        child: Center(
                            child: Text(
                                "Save ${product['discount'].toString()} %")),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
