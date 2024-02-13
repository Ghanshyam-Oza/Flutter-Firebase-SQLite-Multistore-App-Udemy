import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.82,
        width: MediaQuery.of(context).size.width * 0.03,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 249, 234, 93),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: RotatedBox(
            quarterTurns: 3,
            child: Text("Sidebar"),
          ),
        ),
      ),
    );
  }
}
