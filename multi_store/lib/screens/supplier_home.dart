import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store/screens/category.dart';
import 'package:multi_store/screens/home.dart';
import 'package:multi_store/screens/store.dart';
import 'package:multi_store/screens/supplier_dashboard.dart';
import 'package:multi_store/screens/upload_screen.dart';
import 'package:multi_store/widgets/my_snackbar.dart';

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({super.key});

  @override
  State<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  var _selectedIndex = 0;
  final List<Widget> _tabs = const [
    HomeScreen(),
    CategoryScreen(),
    StoreScreen(),
    SupplierDashboardScreen(),
    UploadScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('deliverystatus', isEqualTo: 'preparing')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          MySnackBar.showSnackBar(
              context: context, content: 'Something went wrong');
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

        return Scaffold(
          body: _tabs[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            elevation: 0,
            currentIndex: _selectedIndex,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Category',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.shop),
                label: 'Stores',
              ),
              BottomNavigationBarItem(
                icon: Badge(
                    isLabelVisible: snapshot.data!.docs.isEmpty ? false : true,
                    backgroundColor: Colors.yellow,
                    label: Text(
                      snapshot.data!.docs.length.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: const Icon(Icons.dashboard)),
                label: 'Dashboard',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.upload),
                label: 'Upload',
              ),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
