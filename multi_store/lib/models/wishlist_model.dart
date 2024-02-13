import 'package:flutter/material.dart';
import 'package:multi_store/providers/cart_provider.dart';
import 'package:multi_store/providers/product.dart';
import 'package:multi_store/providers/wish_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class WishlistModel extends StatelessWidget {
  const WishlistModel({
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
          height: 110,
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
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<WishList>()
                                      .removeProduct(product);
                                },
                                icon: const Icon(Icons.delete_forever),
                              ),
                              context.watch<Cart>().getItems.firstWhereOrNull(
                                              (element) =>
                                                  element.documentId ==
                                                  product.documentId) !=
                                          null ||
                                      product.totalQuantity == 0
                                  ? const SizedBox()
                                  : IconButton(
                                      onPressed: () {
                                        context.read<Cart>().addItem(
                                              product.name,
                                              product.price,
                                              1,
                                              product.totalQuantity,
                                              product.imageUrl,
                                              product.documentId,
                                              product.supplierId,
                                            );
                                      },
                                      icon: const Icon(Icons
                                          .shopping_cart_checkout_outlined),
                                    ),
                            ],
                          )
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
