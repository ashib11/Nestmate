import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String? iconPath;
  final IconData? icon;
  final VoidCallback onPressed;

  const SocialLoginButton({
    required this.text,
    this.iconPath,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: iconPath != null
            ? SvgPicture.asset(iconPath!, width: 24, height: 24)
            : Icon(icon, color: Colors.black),
        label: Text(text, style: TextStyle(color: Colors.black)),
        onPressed: onPressed,
      ),
    );
  }
}