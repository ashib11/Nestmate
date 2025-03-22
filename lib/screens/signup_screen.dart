import 'package:flutter/material.dart';
import '../widgets/social_login_button.dart';
import 'home_screen.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Center(
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
                      'Enter your email or phone number to sign up for this app',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              CustomTextField(
                hintText: "Full Name",
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "Enter Address or Phone Number",
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "Password",
                isPassword: true,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "Confirm Password",
                isPassword: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  'or',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SocialLoginButton(
                text: "Continue with Google",
                iconPath: "assets/icons/google.svg.svg",
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              SocialLoginButton(
                text: "Continue with Apple",
                icon: Icons.apple,
                onPressed: () {},
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "By clicking continue, you agree to our Terms of Service and Privacy Policy",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}