import 'package:flutter/material.dart';
import 'package:multistore_customer/models/cart_model.dart';
import 'package:multistore_customer/providers/cart_provider.dart';
import 'package:multistore_customer/providers/id_provider.dart';
import 'package:multistore_customer/screens/place_order.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.isBackButton});
  final bool? isBackButton;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<String> customerid;

  String custId = '';

  @override
  void initState() {
    super.initState();
    customerid = context.read<IdProvider>().getFutureId();
    custId = context.read<IdProvider>().getData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        leading: widget.isBackButton != null && widget.isBackButton == true
            ? const BackButton(color: Colors.black)
            : null,
        title: const Text(
          "Cart",
          style: TextStyle(
            fontFamily: 'Acme',
            fontSize: 28,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          context.watch<Cart>().getItems.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Clear Cart"),
                          content: const Text("Are you sure ? "),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<Cart>().clearCart();
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    size: 30,
                  ),
                ),
        ],
      ),
      body: FutureBuilder<String>(
        future: customerid,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              if (context.watch<Cart>().getItems.isNotEmpty) {
                return const CartItems();
              } else {
                return const EmptyCart();
              }
          }
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  "Total : \$ ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  context.watch<Cart>().totalPrice.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(25)),
              child: MaterialButton(
                onPressed: context.watch<Cart>().totalPrice == 0.0
                    ? null
                    : () {
                        if (custId != '') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PlaceOrderScreen()));
                        } else {
                          showLoginDialog();
                        }
                      },
                child: const Text(
                  "CHECK OUT",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login"),
          content:
              const Text("You need to Login first to access cart checkout."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/customer_login");
                },
                child: const Text("Login"))
          ],
        );
      },
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Your Cart Is Empty !",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 40,
          ),
          Material(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(25),
            child: MaterialButton(
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, '/customer_home');
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 45),
      child: Consumer<Cart>(
        builder: (context, cart, child) {
          return ListView.builder(
            itemCount: cart.getCount,
            itemBuilder: (context, index) {
              var product = cart.getItems[index];
              return CartModel(product: product);
            },
          );
        },
      ),
    );
  }
}

class ModalBottomSheetButton extends StatelessWidget {
  const ModalBottomSheetButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 212, 212, 212),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(191, 0, 0, 0),
            ),
          ),
        ),
      ),
    );
  }
}
