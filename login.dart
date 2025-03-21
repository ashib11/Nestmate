import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import SVG package

void main() {
  runApp(NestMateApp());
}

class NestMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(
                "Elevate Your Home Experience",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 20),
              Image.asset("assets/logo.jpg", width: 250),
              SizedBox(height: 12),
              SizedBox(height: 12),
              Text(
                "Log in to NestMate",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintText: "Email address or phone number",
                isPassword: false,
              ),
              SizedBox(height: 10),
              CustomTextField(
                hintText: "Password",
                isPassword: true,
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Log in",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Forgotten password?",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  children: [
                    TextSpan(text: "Sign up ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green)),
                    TextSpan(
                      text: "for NestMate",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SocialLoginButton(
                text: "Continue with Google",
                iconPath: "assets/icons/google.svg.svg",
                onPressed: () {},
              ),
              SizedBox(height: 10),
              SocialLoginButton(
                text: "Continue with Apple",
                icon: Icons.apple,
                onPressed: () {},
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;

  const CustomTextField({required this.hintText, required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

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