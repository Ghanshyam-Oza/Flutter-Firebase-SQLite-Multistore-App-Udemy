import 'package:flutter/material.dart';
import 'package:multistore_supplier/minor_screens/sub_category_product.dart';

class CategoryPageListScreen extends StatelessWidget {
  const CategoryPageListScreen(
      {super.key, required this.cat, required this.catLabel});
  final List<String> cat;
  final String catLabel;

  String capitalize(String lable) {
    return lable[0].toUpperCase() + lable.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          capitalize(catLabel),
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.74,
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(
              cat.length - 1,
              (index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SubCategoryProduct(
                        subCat: cat[index + 1],
                        cat: catLabel,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  child: Column(
                    children: [
                      Image(
                        image:
                            AssetImage('images/$catLabel/$catLabel$index.jpg'),
                        fit: BoxFit.cover,
                        height: 110,
                        width: 110,
                      ),
                      Text(capitalize(cat[index + 1])),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
