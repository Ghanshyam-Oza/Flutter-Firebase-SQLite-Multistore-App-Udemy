import 'package:flutter/material.dart';
import 'package:multistore_supplier/minor_screens/category_page_list.dart';
import 'package:multistore_supplier/utilities/categ_list.dart';
import 'package:multistore_supplier/widgets/fake_search.dart';
// import 'package:multistore_supplier/widgets/sidebar.dart';

List<ItemData> items = [
  ItemData(label: "Men"),
  ItemData(label: "Women"),
  ItemData(label: "Shoes"),
  ItemData(label: "Electro-\nnics"),
  ItemData(label: "Accesso-\nries"),
  ItemData(label: "Bags"),
  ItemData(label: "Home & \nGarden"),
  ItemData(label: "Kids"),
  ItemData(label: "Beauty"),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _pageController = PageController();

  @override
  void initState() {
    for (final ele in items) {
      ele.isSelected = false;
    }
    items[0].isSelected = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const FakeSearch(),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: sideNav(size),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: catView(size),
          ),
          // not including sidebar
          // const Sidebar(),
        ],
      ),
    );
  }

  Widget sideNav(Size size) {
    return SizedBox(
      height: size.height * 0.82,
      width: size.width * 0.20,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          return InkWell(
            onTap: () {
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceInOut);
            },
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: items[index].isSelected == true
                    ? Colors.white
                    : Colors.yellow.shade400,
              ),
              child: Center(
                child: Text(
                  items[index].label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: items[index].isSelected
                          ? const Color.fromARGB(255, 87, 87, 87)
                          : Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget catView(Size size) {
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.75,
      child: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          for (final ele in items) {
            ele.isSelected = false;
          }
          setState(() {
            items[index].isSelected = true;
          });
        },
        children: [
          CategoryPageListScreen(
            cat: men,
            catLabel: 'men',
          ),
          CategoryPageListScreen(
            cat: women,
            catLabel: 'women',
          ),
          CategoryPageListScreen(
            cat: shoes,
            catLabel: 'shoes',
          ),
          CategoryPageListScreen(
            cat: electronics,
            catLabel: 'electronics',
          ),
          CategoryPageListScreen(
            cat: accessories,
            catLabel: 'accessories',
          ),
          CategoryPageListScreen(
            cat: bags,
            catLabel: 'bags',
          ),
          CategoryPageListScreen(
            cat: home,
            catLabel: 'home',
          ),
          CategoryPageListScreen(
            cat: kids,
            catLabel: 'kids',
          ),
          CategoryPageListScreen(
            cat: beauty,
            catLabel: 'beauty',
          ),
        ],
      ),
    );
  }
}

class ItemData {
  ItemData({required this.label, this.isSelected = false});
  final String label;
  bool isSelected;
}
