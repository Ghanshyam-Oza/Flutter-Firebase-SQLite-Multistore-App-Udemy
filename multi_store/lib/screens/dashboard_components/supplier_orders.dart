import 'package:flutter/material.dart';
import 'package:multi_store/screens/dashboard_components/delivered.dart';
import 'package:multi_store/screens/dashboard_components/preparing.dart';
import 'package:multi_store/screens/dashboard_components/shipping.dart';
import 'package:multi_store/widgets/appbar_title.dart';

class SupplierOrdersScreen extends StatelessWidget {
  const SupplierOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const AppBarTitle(label: 'Orders'),
          bottom: const TabBar(
            indicatorColor: Colors.yellow,
            indicatorWeight: 5.0,
            tabs: [
              RepeatedTab(label: 'Preparing'),
              RepeatedTab(label: 'Shipping'),
              RepeatedTab(label: 'Delivered'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Preparing(),
            Shipping(),
            Delivered(),
          ],
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  const RepeatedTab({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ),
    );
  }
}
