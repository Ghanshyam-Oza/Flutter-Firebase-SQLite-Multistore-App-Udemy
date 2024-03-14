import 'package:flutter/material.dart';
import 'package:multistore_supplier/screens/galleries/gallary_screen.dart';
import 'package:multistore_supplier/widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const SafeArea(child: FakeSearch()),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.yellow,
            tabAlignment: TabAlignment.center,
            indicatorWeight: 8,
            tabs: [
              RepeatedTab(label: 'Men'),
              RepeatedTab(label: 'Women'),
              RepeatedTab(label: 'Shoes'),
              RepeatedTab(label: 'Bags'),
              RepeatedTab(label: 'Electronics'),
              RepeatedTab(label: 'Accessories'),
              RepeatedTab(label: 'Home and Garden'),
              RepeatedTab(label: 'Kids'),
              RepeatedTab(label: 'Beauty'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GallaryScreen(category: 'men'),
            GallaryScreen(category: 'women'),
            GallaryScreen(category: 'shoes'),
            GallaryScreen(category: 'bags'),
            GallaryScreen(category: 'electronics'),
            GallaryScreen(category: 'accessories'),
            GallaryScreen(category: 'home & garden'),
            GallaryScreen(category: 'kids'),
            GallaryScreen(category: 'beauty'),
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
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
