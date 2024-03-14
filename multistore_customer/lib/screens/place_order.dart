import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multistore_customer/minor_screens/add_address.dart';
import 'package:multistore_customer/minor_screens/address_book.dart';
import 'package:multistore_customer/providers/cart_provider.dart';
import 'package:multistore_customer/providers/id_provider.dart';
import 'package:multistore_customer/screens/payment.dart';
import 'package:multistore_customer/widgets/appbar_title.dart';
import 'package:multistore_customer/widgets/my_snackbar.dart';
import 'package:provider/provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> customerStream = FirebaseFirestore.instance
        .collection("customers")
        .where('cid', isEqualTo: context.read<IdProvider>().getData)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: customerStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          MySnackBar.showSnackBar(
              context: context, content: 'Something went wrong.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.yellow,
              ),
            ),
          );
        }

        var data = snapshot.data!.docs[0];
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.grey.shade200,
            title: const AppBarTitle(label: 'Place Order'),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 70),
            child: Column(
              children: [
                Container(
                  // height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: data['address'] == ''
                      ? Container(
                          alignment: Alignment.center,
                          child: MaterialButton(
                            height: 20,
                            color: Colors.yellow,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    settings:
                                        const RouteSettings(name: "PlaceOrder"),
                                    builder: (context) => AddAddressScreen(
                                          customer: data,
                                          sourcePage: 'PlaceOrder',
                                        )),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Add Address First",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    settings:
                                        const RouteSettings(name: "PlaceOrder"),
                                    builder: (context) => AddressBookScreen(
                                          customer: data,
                                          sourcePage: 'PlaceOrder',
                                          isFromAddAdress: false,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Name: "),
                                    Expanded(
                                      child: Text(
                                        data['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Phone: "),
                                    Text(
                                      data['phone'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Address: "),
                                    Expanded(
                                      child: Text(
                                        data['address'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Consumer<Cart>(
                      builder: (context, cart, child) {
                        return ListView.builder(
                          itemCount: cart.getCount,
                          itemBuilder: (context, index) {
                            var order = cart.getItems[index];
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.9),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                      child: Image.network(
                                        order.imageUrl,
                                        height: 100,
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              order.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\$ ${order.price.toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  "X ${order.orderedQuantity}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                  ),
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
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomSheet: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: MaterialButton(
              color: Colors.yellow,
              onPressed: () {
                data['address'] == ''
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: "PlaceOrder"),
                          builder: (context) => AddAddressScreen(
                            customer: data,
                            sourcePage: 'PlaceOrder',
                          ),
                        ),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentScreen()));
              },
              child: Text(
                  "Confirm ${context.watch<Cart>().totalPrice.toStringAsFixed(2)} USD"),
            ),
          ),
        );
      },
    );
  }
}
