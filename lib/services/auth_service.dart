import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current authenticated user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Save user details to Firestore
  Future<void> _saveUserToFirestore(String uid, String firstName, String lastName, String email) async {
    try {
      await _firestore.collection("users").doc(uid).set({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "createdAt": Timestamp.now(),
      });
    } catch (e) {
      print("Firestore Save Error: $e");
    }
  }

  // Signup function
  Future<User?> signUp(String email, String password, String firstName, String lastName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName('$firstName $lastName');
        await _saveUserToFirestore(user.uid, firstName, lastName, email);
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw "Password does not meet the requirements.";
      }
      throw e.message ?? "Sign up failed. Please try again.";
    } catch (e) {
      throw "An unexpected error occurred. Please try again.";
    }
  }


  // Login function
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("This is the printed thing ");
      print(userCredential.user);
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

  // Update user's full name in Firebase Auth and Firestore
  Future<void> updateFullName(String firstName, String lastName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName('$firstName $lastName');
        await _firestore.collection("users").doc(user.uid).update({
          "firstName": firstName,
          "lastName": lastName,
        });
      }
    } catch (e) {
      print("Update Full Name Error: $e");
    }
  }

  // Delete user account from Firebase Auth and Firestore
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
