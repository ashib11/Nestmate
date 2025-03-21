import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(NestMateApp());
}

class NestMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              IconButton(
                icon: Icon(Icons.arrow_back, size: 28),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'NestMate',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Create an account',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Enter your email to sign up for this app',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(hintText: "Full Name"),
              CustomTextField(hintText: "Email address or phone number"),
              CustomTextField(hintText: "Password", obscureText: true),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: Text("Continue", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              SizedBox(height: 10),
              Center(child: Text("or", style: TextStyle(fontSize: 16, color: Colors.grey[600]))),
              SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: Colors.black26),
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/google.svg.svg", width: 24, height: 24),
                  label: Text("Continue with Google", style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: Colors.black26),
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.apple, color: Colors.black),
                  label: Text("Continue with Apple", style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),

              SizedBox(height: 20),
              Center(
                child: Text(
                  "By clicking continue, you agree to our Terms of Service and Privacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;

  CustomTextField({required this.hintText, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black26),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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

  SocialLoginButton({required this.text, this.iconPath, this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(color: Colors.black26),
        ),
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon, size: 24, color: Colors.black)
            : SvgPicture.asset(iconPath!, height: 24),
        label: Text(text, style: TextStyle(fontSize: 16, color: Colors.black87)),
      ),
    );
  }
}
