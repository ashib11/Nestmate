import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_login_button.dart';
import '../services/auth_service.dart'; // Import your AuthService
import '../widgets/cliperbanner.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false; // Track loading state

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please enter email and password.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Authenticate user
      var user = await AuthService().signIn(email, password);

      if (user == null) {
        setState(() {
          _errorMessage = "Invalid email or password.";
        });
        return;
      }

      // 2. Try to get user data (but don't block login if it fails)
      try {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data()!;

          // 3. Try to save locally (but don't block login if it fails)
          try {
            await saveUserDataLocally(userData);
          } catch (e) {
            print("Warning: Failed to save user data locally: $e");
            // Continue login anyway
          }
        }
      } catch (e) {
        print("Warning: Failed to fetch user data: $e");
        // Continue login anyway
      }

      // 4. Proceed to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Safer version of saveUserDataLocally
  Future<void> saveUserDataLocally(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Convert Timestamps to strings if present
      final sanitizedData = userData.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(key, value.toDate().toString());
        }
        return MapEntry(key, value);
      });
      await prefs.setString('userData', jsonEncode(sanitizedData));
    } catch (e) {
      print("Error saving user data: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Full-width image at the top
            ClipPath(
              clipper: InvertedHouseClipper(),
              child: Container(
                color: Colors.green[600],
                width: double.infinity,
                height: 400,
                child:
                Image.asset(
                  'assets/GIF.gif',
                  height: 80,
                  gaplessPlayback: true,
                  width: double.infinity,
                )
              ),
            ),
            // Padding starts here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'NestMate',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  // const SizedBox(height: 5),
                  // Text(
                  //   'Log in to NestMate',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Email address or phone number",
                    isPassword: false,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: "Password",
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Log in",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgotten password?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Sign up ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          TextSpan(
                            text: "for NestMate",
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Center(
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
