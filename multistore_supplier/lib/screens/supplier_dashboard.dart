// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multistore_supplier/minor_screens/edit_store.dart';
import 'package:multistore_supplier/minor_screens/visit_store.dart';
import 'package:multistore_supplier/providers/auth_repo.dart';
import 'package:multistore_supplier/screens/dashboard_components/supplier_balance.dart';
import 'package:multistore_supplier/screens/dashboard_components/supplier_manage_products.dart';
import 'package:multistore_supplier/screens/dashboard_components/supplier_orders.dart';
import 'package:multistore_supplier/screens/dashboard_components/supplier_statistics.dart';
import 'package:multistore_supplier/widgets/my_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> label = [
  'my store',
  'orders',
  'edit store',
  'manage\nproducts',
  'balance',
  'statistics'
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

class SupplierDashboardScreen extends StatefulWidget {
  const SupplierDashboardScreen({super.key});

  @override
  State<SupplierDashboardScreen> createState() =>
      _SupplierDashboardScreenState();
}

class _SupplierDashboardScreenState extends State<SupplierDashboardScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, dynamic> data = {};

  getSupplierData() async {
    FirebaseFirestore.instance
        .collection("suppliers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        data = snapshot.data() as Map<String, dynamic>;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getSupplierData();
    List<Widget> dashboardWidgets = [
      VisitStoreScreen(supplierId: FirebaseAuth.instance.currentUser!.uid),
      const SupplierOrdersScreen(),
      EditStore(data: data),
      const SupplierManageProductsScreen(),
      const SupplierBalanceScreen(),
      const SupplierStatisticsScreen(),
    ];

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
                final SharedPreferences prefs = await _prefs;
                prefs.setString("supplierid", "");
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            backgroundColor: Colors.white,
            fontFamily: 'Acme',
            fontSize: 26,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: List.generate(
            6,
            (index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => dashboardWidgets[index]));
                },
                child: Card(
                  color: Colors.yellow.shade400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        size: 50,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        label[index].toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
