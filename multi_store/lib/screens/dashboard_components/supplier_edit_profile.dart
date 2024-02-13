import 'package:flutter/material.dart';
import 'package:multi_store/widgets/appbar_title.dart';

class SupplierEditProfileScreen extends StatelessWidget {
  const SupplierEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const AppBarTitle(label: 'Edit Profile'),
      ),
    );
  }
}
