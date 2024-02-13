import 'package:flutter/material.dart';
import 'package:multi_store/widgets/appbar_title.dart';

class SupplierStatisticsScreen extends StatelessWidget {
  const SupplierStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const AppBarTitle(
          label: 'Statistics',
        ),
      ),
    );
  }
}
