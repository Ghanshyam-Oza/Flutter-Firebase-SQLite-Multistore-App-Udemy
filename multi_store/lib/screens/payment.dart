// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store/providers/cart_provider.dart';
import 'package:multi_store/providers/stripe.dart';
import 'package:multi_store/widgets/appbar_title.dart';
import 'package:multi_store/widgets/my_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  var selectedValue = 1;
  bool isProcessing = false;

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(msg: "Please Wait...");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          MySnackBar.showSnackBar(
              context: context, content: 'Something went wrong.');
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          var totalPrice = context.watch<Cart>().totalPrice;
          var totalPaid = context.watch<Cart>().totalPrice + 10.0;

          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.grey.shade200,
              title: const AppBarTitle(label: 'Payment'),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 70),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${totalPaid.toStringAsFixed(2)} USD",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Order",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Text(
                                "${totalPrice.toStringAsFixed(2)} USD",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Shipping Cost",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              Text(
                                "10.00 USD",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
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
                      child: Column(
                        children: [
                          RadioListTile(
                            value: 1,
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value!;
                              });
                            },
                            title: const Text("Cash On Delivery"),
                            subtitle: const Text("Pay Cash At Home"),
                          ),
                          RadioListTile(
                            value: 2,
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value!;
                              });
                            },
                            title: const Text("Pay via Visa / Mastercard"),
                            subtitle: const Row(
                              children: [
                                Icon(Icons.payment, color: Colors.blue),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Icon(FontAwesomeIcons.ccVisa,
                                      color: Colors.blue),
                                ),
                                Icon(FontAwesomeIcons.ccMastercard,
                                    color: Colors.blue),
                              ],
                            ),
                          ),
                          RadioListTile(
                            value: 3,
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value!;
                              });
                            },
                            title: const Text("Pay via Paypal"),
                            subtitle: const Row(
                              children: [
                                Icon(FontAwesomeIcons.paypal,
                                    color: Colors.blue),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(FontAwesomeIcons.ccPaypal,
                                    color: Colors.blue),
                              ],
                            ),
                          ),
                        ],
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
                onPressed: () async {
                  if (selectedValue == 1) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Pay At Home ${totalPaid.toStringAsFixed(2)} \$",
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MaterialButton(
                                color: Colors.yellow,
                                minWidth: double.infinity,
                                onPressed: isProcessing
                                    ? null
                                    : () async {
                                        setState(() {
                                          isProcessing = true;
                                        });
                                        showProgress();
                                        CollectionReference orderRef =
                                            FirebaseFirestore.instance
                                                .collection('orders');
                                        for (final item
                                            in context.read<Cart>().getItems) {
                                          final orderId = const Uuid().v4();
                                          await orderRef.doc(orderId).set(
                                            {
                                              'cid': data['cid'],
                                              'custname': data['name'],
                                              'email': data['email'],
                                              'address': data['address'],
                                              'phone': data['phone'],
                                              'profileimage':
                                                  data['profileimage'],
                                              'sid': item.supplierId,
                                              'productid': item.documentId,
                                              'orderid': orderId,
                                              'ordername': item.name,
                                              'orderimage': item.imageUrl.first,
                                              'orderquantity':
                                                  item.orderedQuantity,
                                              'orderprice':
                                                  item.orderedQuantity *
                                                      item.price,
                                              'deliverystatus': 'preparing',
                                              'deliverydate': '',
                                              'orderdate': DateTime.now(),
                                              'paymentstatus':
                                                  'cash on delivery',
                                              'orderreview': false,
                                            },
                                          ).whenComplete(() async {
                                            await FirebaseFirestore.instance
                                                .runTransaction(
                                                    (transaction) async {
                                              DocumentReference
                                                  documentReference =
                                                  FirebaseFirestore.instance
                                                      .collection("products")
                                                      .doc(item.documentId);
                                              DocumentSnapshot snapshot2 =
                                                  await transaction
                                                      .get(documentReference);
                                              transaction.update(
                                                  documentReference, {
                                                'instock':
                                                    snapshot2['instock'] -
                                                        item.orderedQuantity
                                              });
                                            });
                                          });
                                          setState(() {
                                            isProcessing = false;
                                          });
                                        }
                                        context.read<Cart>().clearCart();
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                '/customer_home'));
                                      },
                                child: Text(
                                    "Confirm ${totalPaid.toStringAsFixed(2)} \$"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (selectedValue == 2) {
                    await stripeMakePayment();
                  } else if (selectedValue == 3) {
                    print("Paypal");
                  }
                },
                child: Text("Confirm ${totalPaid.toStringAsFixed(2)} USD"),
              ),
            ),
          );
        }
        return const Material(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.yellow,
            ),
          ),
        );
      },
    );
  }

  Future<void> stripeMakePayment() async {
    try {
      Map<String, dynamic>? paymentIntent;
      paymentIntent = await createPaymentIntent('10000', 'INR');

      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "IN", currencyCode: "INR", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Abhi',
                  googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((e) {
        Stripe.instance.confirmPaymentSheetPayment();
      });
    } catch (e) {
      print('$e');
    }
  }

//create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecretkey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
