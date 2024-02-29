import 'package:flutter/material.dart';

class BestDealsModel extends StatelessWidget {
  const BestDealsModel({super.key, required this.product});
  final dynamic product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.pushReplacementNamed(context, '/welcome_screen');
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/welcome_screen', (Route<dynamic> route) => false);
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
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/welcome_screen',
                                    (Route<dynamic> route) => false);
                              },
                              icon: const Icon(
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
