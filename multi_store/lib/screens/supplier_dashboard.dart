// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/minor_screens/visit_store.dart';
import 'package:multi_store/screens/dashboard_components/supplier_balance.dart';
import 'package:multi_store/screens/dashboard_components/supplier_edit_profile.dart';
import 'package:multi_store/screens/dashboard_components/supplier_manage_products.dart';
import 'package:multi_store/screens/dashboard_components/supplier_orders.dart';
import 'package:multi_store/screens/dashboard_components/supplier_statistics.dart';
import 'package:multi_store/widgets/my_snackbar.dart';

List<String> label = [
  'my store',
  'orders',
  'edit Profile',
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

List<Widget> dashboardWidgets = [
  VisitStoreScreen(supplierId: FirebaseAuth.instance.currentUser!.uid),
  const SupplierOrdersScreen(),
  const SupplierEditProfileScreen(),
  const SupplierManageProductsScreen(),
  const SupplierBalanceScreen(),
  const SupplierStatisticsScreen(),
];

class SupplierDashboardScreen extends StatelessWidget {
  const SupplierDashboardScreen({super.key});

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
