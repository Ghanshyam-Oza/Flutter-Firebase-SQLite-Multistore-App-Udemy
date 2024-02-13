import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store/providers/cart_provider.dart';
import 'package:multi_store/providers/product.dart';
import 'package:multi_store/providers/wish_list_provider.dart';
import 'package:multi_store/screens/cart.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        child: Container(
          height: 100,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                height: 85,
                width: 120,
                child: Image.network(
                  product.imageUrl.first,
                  fit: BoxFit.contain,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(162, 0, 0, 0),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ('\$ ') + product.price.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                product.orderedQuantity == 1
                                    ? IconButton(
                                        onPressed: () {
                                          // cart.removeProduct(product);
                                          showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 20.0,
                                                    horizontal: 10.0,
                                                  ),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.25,
                                                    width: double.infinity,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        const Text(
                                                          "Delete Item ?",
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        ModalBottomSheetButton(
                                                            label:
                                                                'Move to Wishlist',
                                                            onPressed: () {
                                                              context.read<WishList>().getWishListItems.firstWhereOrNull((item) =>
                                                                          item.documentId ==
                                                                          product
                                                                              .documentId) !=
                                                                      null
                                                                  ? null
                                                                  : context
                                                                      .read<
                                                                          WishList>()
                                                                      .addWishListItem(
                                                                        product
                                                                            .name,
                                                                        product
                                                                            .price,
                                                                        product
                                                                            .orderedQuantity,
                                                                        product
                                                                            .totalQuantity,
                                                                        product
                                                                            .imageUrl,
                                                                        product
                                                                            .documentId,
                                                                        product
                                                                            .supplierId,
                                                                      );

                                                              context
                                                                  .read<Cart>()
                                                                  .removeProduct(
                                                                      product);
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                        ModalBottomSheetButton(
                                                          label: 'Delete Item',
                                                          onPressed: () {
                                                            context
                                                                .read<Cart>()
                                                                .removeProduct(
                                                                    product);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        ModalBottomSheetButton(
                                                          label: 'Cancel',
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever,
                                          size: 14,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          context
                                              .read<Cart>()
                                              .reduceByOne(product);
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.minus,
                                          size: 14,
                                        ),
                                      ),
                                Text(
                                  product.orderedQuantity.toString(),
                                  style: product.orderedQuantity ==
                                          product.totalQuantity
                                      ? const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.red,
                                        )
                                      : const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                ),
                                product.orderedQuantity == product.totalQuantity
                                    ? const IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          FontAwesomeIcons.plus,
                                          size: 14,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          context
                                              .read<Cart>()
                                              .increaseByOne(product);
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.plus,
                                          size: 14,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
