import 'package:flutter/material.dart';

class InvertedHouseClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height); // bottom-left
    path.lineTo(size.width / 2, size.height -95); // peak of the triangle
    path.lineTo(size.width, size.height); // bottom-right
    path.lineTo(size.width, 0); // top-right
    path.lineTo(0, 0); // back to top-left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}