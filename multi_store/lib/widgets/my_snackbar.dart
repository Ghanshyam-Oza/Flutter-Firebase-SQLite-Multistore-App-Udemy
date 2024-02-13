import 'package:flutter/material.dart';

class MySnackBar {
  static void showSnackBar(
      {required BuildContext context, required String content}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: const TextStyle(fontSize: 18),
        ),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}
