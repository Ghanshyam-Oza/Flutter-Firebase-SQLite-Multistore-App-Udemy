import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multistore_customer/providers/id_provider.dart';
import 'package:provider/provider.dart';

class CustomerOrderModel extends StatefulWidget {
  const CustomerOrderModel({super.key, required this.order});
  final dynamic order;

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  double rate = 5;
  String comment = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3, color: Colors.yellow),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 80, maxWidth: 80),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(widget.order['orderimage']),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order['ordername'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$ ${widget.order['orderprice'].toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "X ${widget.order['orderquantity'].toString()}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("See more..."),
                Text(widget.order['deliverystatus'])
              ],
            ),
          ),
          children: [
            Container(
              // height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.order['deliverystatus'] == 'delivered'
                    ? Colors.grey.withOpacity(0.1)
                    : Colors.yellow.withOpacity(0.4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${widget.order['custname']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Phone Number: ${widget.order['phone']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Email Adress: ${widget.order['email']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Address: ${widget.order['address']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Payment Status: ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          widget.order['paymentstatus'],
                          style: const TextStyle(
                              fontSize: 16, color: Colors.purple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Delivery Status: ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          widget.order['deliverystatus'],
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    widget.order['deliverystatus'] == 'shipping'
                        ? Text(
                            "Estimated Delivery Date: ${DateFormat('yyyy-MM-dd').format(widget.order['deliverydate'].toDate())}",
                            style: const TextStyle(fontSize: 16),
                          )
                        : const SizedBox(),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == true
                        ? const Padding(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Review Added",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    widget.order['deliverystatus'] == 'delivered' &&
                            widget.order['orderreview'] == false
                        ? TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "What is you rate?",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 10),
                                          RatingBar.builder(
                                            initialRating: 5,
                                            minRating: 1,
                                            allowHalfRating: true,
                                            itemBuilder: (context, _) {
                                              return const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              );
                                            },
                                            onRatingUpdate: (value) {
                                              rate = value;
                                            },
                                          ),
                                          const SizedBox(height: 30),
                                          const Text(
                                            "Please share your opinion \nabout the product",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            decoration: const InputDecoration(
                                              hintText: 'Write Review',
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                            maxLines: 6,
                                            keyboardType: TextInputType.text,
                                            onChanged: (value) {
                                              comment = value;
                                            },
                                          ),
                                          const SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  final collectionReference =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "products")
                                                          .doc(widget.order[
                                                              'productid'])
                                                          .collection(
                                                              "reviews");

                                                  var customerId = context
                                                      .read<IdProvider>()
                                                      .getData;
                                                  await collectionReference
                                                      .doc(customerId)
                                                      .set({
                                                    'name': widget
                                                        .order['custname'],
                                                    'email':
                                                        widget.order['email'],
                                                    'profileimage': widget
                                                        .order['profileimage'],
                                                    'rate': rate,
                                                    'comment': comment,
                                                    'orderid':
                                                        widget.order['orderid'],
                                                    'cid': customerId,
                                                  });

                                                  await FirebaseFirestore
                                                      .instance
                                                      .runTransaction(
                                                          (transaction) {
                                                    return FirebaseFirestore
                                                        .instance
                                                        .collection('orders')
                                                        .doc(widget
                                                            .order['orderid'])
                                                        .update({
                                                      'orderreview': true
                                                    });
                                                  });

                                                  Future.delayed(const Duration(
                                                          microseconds: 100))
                                                      .whenComplete(() =>
                                                          Navigator.pop(
                                                              context));
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.yellow,
                                                  ),
                                                  child: const Center(
                                                      child: Text(
                                                    "Share Review",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.yellow,
                                                  ),
                                                  child: const Center(
                                                      child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Write Review",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
