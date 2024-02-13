// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/screens/cart.dart';
import 'package:multi_store/screens/customer_screens/customer_orders.dart';
import 'package:multi_store/screens/customer_screens/customer_wishlist.dart';
import 'package:multi_store/widgets/my_snackbar.dart';
import 'package:multi_store/widgets/profile_header.dart';
import 'package:multi_store/widgets/repeated_divider.dart';
import 'package:multi_store/widgets/repeated_listtile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.documentId});
  final String documentId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  @override
  Widget build(BuildContext context) {
    void logout() async {
      Widget alertDialog = AlertDialog(
        title: const Text("Logout Action"),
        content: const Text("Are you sure want to logout?"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/welcome_screen');
              } on FirebaseAuthException catch (error) {
                MySnackBar.showSnackBar(
                    context: context, content: error.message.toString());
              } catch (error) {
                MySnackBar.showSnackBar(
                    context: context, content: error.toString());
              }
            },
            child: const Text("Yes"),
          ),
        ],
      );
      showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        },
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(widget.documentId).get(),
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
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow,
                        Color.fromARGB(255, 181, 165, 19),
                      ],
                    ),
                  ),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      elevation: 0,
                      pinned: true,
                      expandedHeight: 140,
                      backgroundColor: Colors.white,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          return FlexibleSpaceBar(
                            title: AnimatedOpacity(
                              duration: const Duration(microseconds: 1),
                              opacity:
                                  constraints.biggest.height <= 120 ? 1 : 0,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 90.0),
                                child: Text(
                                  "Account",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            background: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow,
                                    Color.fromARGB(255, 181, 165, 19),
                                  ],
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 40.0, top: 30.0, bottom: 10),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(data['profileimage']),
                                      radius: 50,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Text(
                                      data['name'].toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Cart",
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 20),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  decoration: const BoxDecoration(
                                    color: Colors.yellow,
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CustomerOrdersScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Orders",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CustomerWishlistScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "WishList",
                                      style: TextStyle(
                                          color: Colors.yellow, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration:
                                BoxDecoration(color: Colors.grey.shade200),
                            child: Column(
                              children: [
                                const Image(
                                  image: AssetImage('images/inapp/logo.jpg'),
                                ),
                                const ProfileHeader(
                                  header: "  Account Info  ",
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    height: 260,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        RepeatedListTile(
                                          title: 'Email Address',
                                          subtitle: data['email'],
                                          icon: Icons.email,
                                        ),
                                        const RepeatedDivider(),
                                        RepeatedListTile(
                                          title: "Phone Number",
                                          subtitle: data['phone'],
                                          icon: Icons.phone,
                                        ),
                                        const RepeatedDivider(),
                                        RepeatedListTile(
                                          title: "Address",
                                          subtitle: data['address'],
                                          icon: Icons.location_on,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const ProfileHeader(
                                    header: "  Account Settings  "),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    height: 260,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Column(
                                        children: [
                                          RepeatedListTile(
                                            title: 'Edit Profile',
                                            icon: Icons.edit,
                                            onPressed: () {},
                                          ),
                                          const RepeatedDivider(),
                                          RepeatedListTile(
                                            title: "Change Password",
                                            icon: Icons.lock,
                                            onPressed: () {},
                                          ),
                                          const RepeatedDivider(),
                                          RepeatedListTile(
                                            title: "Logout",
                                            icon: Icons.logout,
                                            onPressed: logout,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Colors.yellow,
          ),
        );
      },
    );
  }
}
