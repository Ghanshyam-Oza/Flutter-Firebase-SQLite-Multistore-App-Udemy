import 'package:flutter/material.dart';

class RepeatedListTile extends StatelessWidget {
  const RepeatedListTile({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.icon,
    this.onPressed,
  });
  final String title;
  final String? subtitle;
  final IconData icon;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.titleHeight,
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle!),
      ),
    );
  }
}
