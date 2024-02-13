import 'package:flutter/material.dart';
import 'package:multi_store/minor_screens/search.dart';

class FakeSearch extends StatelessWidget {
  const FakeSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => const SearchScreen()));
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2, color: Colors.yellow),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.search),
                ),
                Text(
                  "What are you looking for?",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Container(
              height: 30,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Search",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 123, 123, 123)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
