import 'package:flutter/material.dart';

class RepeatedDivider extends StatelessWidget {
  const RepeatedDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Divider(
        thickness: 1,
        color: Colors.grey,
      ),
    );
  }
}
