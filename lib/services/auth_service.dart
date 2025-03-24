import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Signup function
  Future<bool> signUp(String email, String password, String fullName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(fullName);
        await _firestore.collection("users").doc(user.uid).set({
          "fullName": fullName,
          "email": email,
          "createdAt": Timestamp.now(),
        });

        return true;  // Signup successful
      }
      return false; // Failed to sign up
    } catch (e) {
      print("Signup Error: $e");
      return false;
    }
  }


  // Login function
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Logout function
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Logout Error: $e");
    }
  }

  // Forgot password function
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Reset Password Error: $e");
    }
  }

  // Update user's full name
  Future<void> updateFullName(String fullName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(fullName);
        await _firestore.collection("users").doc(user.uid).update({
          "fullName": fullName,
        });
      }
    } catch (e) {
      print("Update Full Name Error: $e");
    }
  }

  // Delete account function
  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection("users").doc(user.uid).delete();
        await user.delete();
      }
    } catch (e) {
      print("Delete Account Error: $e");
    }
  }
}
