import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  FilterButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: TextStyle(color: Colors.black)),
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}