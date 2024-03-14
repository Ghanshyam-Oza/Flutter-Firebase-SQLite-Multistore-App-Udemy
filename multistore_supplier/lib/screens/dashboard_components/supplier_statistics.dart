import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multistore_supplier/widgets/appbar_title.dart';
import 'package:multistore_supplier/widgets/my_snackbar.dart';

class SupplierStatisticsScreen extends StatelessWidget {
  const SupplierStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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

        num totalQuantity = 0;
        for (var item in snapshot.data!.docs) {
          totalQuantity += item['orderquantity'];
        }
        double totalPrice = 0.0;
        for (var item in snapshot.data!.docs) {
          totalPrice += item['orderquantity'] * item['orderprice'];
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: const AppBarTitle(
              label: 'Statistics',
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatisticsModel(
                  label: 'Sold out',
                  value: snapshot.data!.docs.length,
                  decimal: 0,
                  isSignRequired: false,
                ),
                StatisticsModel(
                  label: 'Item Count',
                  value: totalQuantity,
                  decimal: 0,
                  isSignRequired: false,
                ),
                StatisticsModel(
                  label: 'Total Balance',
                  value: totalPrice,
                  decimal: 2,
                  isSignRequired: true,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StatisticsModel extends StatelessWidget {
  final String label;
  final dynamic value;
  final int decimal;
  final bool isSignRequired;
  const StatisticsModel({
    super.key,
    required this.label,
    required this.value,
    required this.decimal,
    required this.isSignRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: AnimatedCount(
            count: value,
            decimal: decimal,
            isSignRequired: isSignRequired,
          ),
        ),
      ],
    );
  }
}

class AnimatedCount extends StatefulWidget {
  const AnimatedCount(
      {super.key,
      required this.count,
      required this.decimal,
      required this.isSignRequired});
  final dynamic count;
  final int decimal;
  final bool isSignRequired;

  @override
  State<AnimatedCount> createState() => _AnimatedCountState();
}

class _AnimatedCountState extends State<AnimatedCount>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = _controller;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count)
          .animate(_controller);
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
          child: Text(
            _animation.value.toStringAsFixed(widget.decimal) +
                (widget.isSignRequired ? ' \$' : ''),
            style: const TextStyle(
              color: Colors.pink,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'Acme',
              letterSpacing: 2,
            ),
          ),
        );
      },
    );
  }
}
