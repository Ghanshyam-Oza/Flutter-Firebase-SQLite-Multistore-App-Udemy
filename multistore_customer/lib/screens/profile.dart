// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multistore_customer/minor_screens/address_book.dart';
import 'package:multistore_customer/minor_screens/update_password.dart';
import 'package:multistore_customer/providers/auth_repo.dart';
import 'package:multistore_customer/providers/id_provider.dart';
import 'package:multistore_customer/screens/cart.dart';
import 'package:multistore_customer/screens/customer_screens/customer_orders.dart';
import 'package:multistore_customer/screens/customer_screens/customer_wishlist.dart';
import 'package:multistore_customer/screens/edit_profile.dart';
import 'package:multistore_customer/widgets/my_snackbar.dart';
import 'package:multistore_customer/widgets/profile_header.dart';
import 'package:multistore_customer/widgets/repeated_divider.dart';
import 'package:multistore_customer/widgets/repeated_listtile.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<String> customerid;
  String custId = '';

  @override
  void initState() {
    super.initState();
    customerid = context.read<IdProvider>().getFutureId();
    custId = context.read<IdProvider>().getData;
  }

  void logout() async {
    Widget alertDialog = AlertDialog(
      title: const Text("Logout Action"),
      content: const Text("Are you sure want to logout?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No")),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await AuthRepo.logOut();
              context.read<IdProvider>().clearCustomerId();
              Navigator.pushReplacementNamed(context, '/onboarding_screen');
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: customerid,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.done:
            if (custId != "") {
              return userScaffold();
            } else {
              return noUserScaffold();
            }
        }
      },
    );
  }

  Widget userScaffold() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("customers")
          .where('cid', isEqualTo: custId)
          .snapshots(),
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
                    expandedHeight: 120,
                    backgroundColor: Colors.white,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        return FlexibleSpaceBar(
                          title: AnimatedOpacity(
                            duration: const Duration(microseconds: 1),
                            opacity: constraints.biggest.height <= 120 ? 1 : 0,
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
                                      left: 40.0, top: 30.0),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(data['profileimage']),
                                    radius: 50,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 25),
                                    child: Text(
                                      data['name'].toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                          height: 75,
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
                                width: MediaQuery.of(context).size.width * 0.25,
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
                                width: MediaQuery.of(context).size.width * 0.3,
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
                                width: MediaQuery.of(context).size.width * 0.25,
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
                                        color: Colors.yellow, fontSize: 18),
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
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddressBookScreen(
                                                customer: data,
                                                sourcePage: 'Profile',
                                                isFromAddAdress: false,
                                              ),
                                            ),
                                          );
                                        },
                                        title: "Address",
                                        subtitle: data['address'] == ''
                                            ? 'Set Your Address'
                                            : data['address'],
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
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfile(
                                                            data: data)));
                                          },
                                        ),
                                        const RepeatedDivider(),
                                        RepeatedListTile(
                                          title: "Change Password",
                                          icon: Icons.lock,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const UpdatePassword()));
                                          },
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
      },
    );
  }

  Widget noUserScaffold() {
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
                expandedHeight: 120,
                backgroundColor: Colors.white,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        duration: const Duration(microseconds: 1),
                        opacity: constraints.biggest.height <= 120 ? 1 : 0,
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
                            const Padding(
                              padding: EdgeInsets.only(left: 40.0, top: 30.0),
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("images/inapp/guest.jpg"),
                                radius: 50,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 25),
                              child: Text(
                                "GUEST",
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: MaterialButton(
                                  color: Colors.yellow,
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, "/customer_login");
                                  },
                                  child: const Text("Login"),
                                ),
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
                      height: 75,
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
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomLeft: Radius.circular(50),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showLoginDialog();
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
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                            ),
                            child: TextButton(
                              onPressed: () {
                                showLoginDialog();
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
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showLoginDialog();
                              },
                              child: const Text(
                                "WishList",
                                style: TextStyle(
                                    color: Colors.yellow, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
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
                                    onPressed: () {
                                      showLoginDialog();
                                    },
                                    title: 'Email Address',
                                    subtitle: "example@gmail.com",
                                    icon: Icons.email,
                                  ),
                                  const RepeatedDivider(),
                                  RepeatedListTile(
                                    onPressed: () {
                                      showLoginDialog();
                                    },
                                    title: "Phone Number",
                                    subtitle: "+9111111111",
                                    icon: Icons.phone,
                                  ),
                                  const RepeatedDivider(),
                                  RepeatedListTile(
                                    onPressed: () {
                                      showLoginDialog();
                                    },
                                    title: "Address",
                                    subtitle: "New Delhi, India",
                                    icon: Icons.location_on,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const ProfileHeader(header: "  Account Settings  "),
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
                                      onPressed: () {
                                        showLoginDialog();
                                      },
                                    ),
                                    const RepeatedDivider(),
                                    RepeatedListTile(
                                      title: "Change Password",
                                      icon: Icons.lock,
                                      onPressed: () {
                                        showLoginDialog();
                                      },
                                    ),
                                    const RepeatedDivider(),
                                    RepeatedListTile(
                                      title: "Logout",
                                      icon: Icons.logout,
                                      onPressed: () {
                                        showLoginDialog();
                                      },
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

  showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login"),
          content: const Text("You need to Login first to access Profile."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
                onPressed: () {
                  // Navigator.pushReplacementNamed(context, "/customer_login");
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/customer_login", (route) => false);
                },
                child: const Text("Login"))
          ],
        );
      },
    );
  }
}
