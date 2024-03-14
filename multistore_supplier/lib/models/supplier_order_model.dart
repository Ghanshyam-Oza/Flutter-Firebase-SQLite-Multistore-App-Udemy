import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class SupplierOrderModel extends StatelessWidget {
  const SupplierOrderModel({super.key, required this.order});
  final dynamic order;

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
                  child: Image.network(order['orderimage']),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['ordername'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$ ${order['orderprice'].toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "X ${order['orderquantity'].toString()}",
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
                Text(order['deliverystatus'])
              ],
            ),
          ),
          children: [
            Container(
              // height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${order['custname']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Phone Number: ${order['phone']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Email Adress: ${order['email']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Address: ${order['address']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Payment Status: ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          order['paymentstatus'],
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
                          order['deliverystatus'],
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Order Date: ",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          (DateFormat('yyyy-MM-dd')
                              .format(order['orderdate'].toDate())
                              .toString()),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    order['deliverystatus'] == "delivered"
                        ? const Text(
                            "This order has been already delivered.",
                            style: TextStyle(fontSize: 16),
                          )
                        : Row(
                            children: [
                              const Text(
                                "Change Delivery Status To: ",
                                style: TextStyle(fontSize: 16),
                              ),
                              order['deliverystatus'] == "preparing"
                                  ? TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            minTime: DateTime.now(),
                                            maxTime: DateTime.now()
                                                .add(const Duration(days: 365)),
                                            onConfirm: (date) async {
                                          await FirebaseFirestore.instance
                                              .collection("orders")
                                              .doc(order['orderid'])
                                              .update({
                                            'deliverystatus': "shipping",
                                            'deliverydate': date,
                                          });
                                        });
                                      },
                                      child: const Text("Shipping ?"),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("orders")
                                            .doc(order['orderid'])
                                            .update({
                                          'deliverystatus': 'delivered',
                                        });
                                      },
                                      child: const Text("delivered ?"),
                                    ),
                            ],
                          ),
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
