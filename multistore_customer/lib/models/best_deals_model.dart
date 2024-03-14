import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:multistore_customer/minor_screens/product_details.dart';
import 'package:multistore_customer/providers/product.dart';
import 'package:multistore_customer/providers/wish_list_provider.dart';
import 'package:provider/provider.dart';

class BestDealsModel extends StatefulWidget {
  const BestDealsModel({super.key, required this.product});
  final dynamic product;

  @override
  State<BestDealsModel> createState() => _BestDealsModelState();
}

class _BestDealsModelState extends State<BestDealsModel> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ProductDetailsScreen(product: widget.product)));
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
                        image: NetworkImage(widget.product['productimages'][0]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['productname'],
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
                                widget.product['discount'] == 0
                                    ? Text(
                                        widget.product['price']
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      )
                                    : Text(
                                        widget.product['price']
                                            .toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                const SizedBox(width: 5),
                                widget.product['discount'] == 0
                                    ? const SizedBox()
                                    : Text(
                                        ((1 -
                                                    widget.product['discount'] /
                                                        100) *
                                                widget.product['price'])
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
                                                widget.product['productid']) !=
                                        null
                                    ? context
                                        .read<WishList>()
                                        .removeThis(widget.product['productid'])
                                    : context.read<WishList>().addWishListItem(Product(
                                        documentId: widget.product['productid'],
                                        name: widget.product['productname'],
                                        price: widget.product['discount'] != 0
                                            ? ((1 -
                                                    widget.product['discount'] /
                                                        100) *
                                                widget.product['price'])
                                            : widget.product['price'],
                                        orderedQuantity: 1,
                                        totalQuantity:
                                            widget.product['instock'],
                                        imageUrl:
                                            widget.product['productimages'][0],
                                        supplierId: widget.product['sid']));
                              },
                              icon: context
                                          .watch<WishList>()
                                          .getWishListItems
                                          .firstWhereOrNull((item) =>
                                              item.documentId ==
                                              widget.product['productid']) !=
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
                      ],
                    ),
                  ),
                ],
              ),
              widget.product['discount'] != 0
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
                                "Save ${widget.product['discount'].toString()} %")),
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
