import 'package:flutter/material.dart';
import 'package:multi_store/widgets/appbar_title.dart';

class SupplierBalanceScreen extends StatelessWidget {
  const SupplierBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const AppBarTitle(label: 'Balance'),
      ),
    );
  }
}
