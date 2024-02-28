import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressBookModel extends StatelessWidget {
  const AddressBookModel({
    super.key,
    required this.addr,
  });

  final QueryDocumentSnapshot<Object?> addr;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: addr['default'] == true ? Colors.yellow : Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: addr['default'] == true
                ? const Icon(Icons.star)
                : const SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    Expanded(
                      child: Text(
                        '${addr['firstname']} ${addr['lastname']}',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Phone Number: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      addr['phone'],
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "City, State: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    Expanded(
                      child: Text(
                        "${addr['city']}, ${addr['state']}",
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text(
                      "Country: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    Expanded(
                      child: Text(
                        "${addr['country']}",
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
