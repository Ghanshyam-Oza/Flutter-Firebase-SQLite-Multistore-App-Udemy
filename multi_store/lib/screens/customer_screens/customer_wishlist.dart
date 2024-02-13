import 'package:flutter/material.dart';
import 'package:multi_store/models/wishlist_model.dart';
import 'package:multi_store/providers/wish_list_provider.dart';
import 'package:provider/provider.dart';

class CustomerWishlistScreen extends StatelessWidget {
  const CustomerWishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Wishlist",
            style: TextStyle(
              fontFamily: 'Acme',
              fontSize: 28,
              letterSpacing: 1.5,
            ),
          ),
          actions: [
            context.watch<WishList>().getWishListItems.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Clear WishList"),
                            content: const Text("Are you sure ? "),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.read<WishList>().clearWishList();
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
        body: context.watch<WishList>().getWishListItems.isNotEmpty
            ? const WishListItems()
            : const EmptyWishList(),
      ),
    );
  }
}

class EmptyWishList extends StatelessWidget {
  const EmptyWishList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your Wishlist Is Empty !",
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class WishListItems extends StatelessWidget {
  const WishListItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 45),
      child: Consumer<WishList>(
        builder: (context, wishlist, child) {
          return ListView.builder(
            itemCount: wishlist.getCount,
            itemBuilder: (context, index) {
              var product = wishlist.getWishListItems[index];
              return WishlistModel(product: product);
            },
          );
        },
      ),
    );
  }
}
