import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userData = {};

  Map<String, dynamic>? get userData => _userData;
  void setUserData(Map<String, dynamic> newUserData) {
    _userData = newUserData;
    notifyListeners();
  }
  bool get hasUserData => _userData?.isNotEmpty ?? false;
  // Helper function
  Future<void> fetchUserData(String userID) async {
    if (_userData != null) return; // Avoid fetching again if data is already loaded

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();

      if (userDoc.exists) {
        _userData = userDoc.data() as Map<String, dynamic>;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
