import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'editProfile_screen.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;
  const ProfileScreen({Key? key, required this.userID}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  String? _userProfileUrl;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  String userNameFirst = "";
  String userNameLast = "";
  String userEmail = "";
  String userGender = "Other";
  String userPhone = "NULL";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');

      if (userDataString != null) {
        Map<String, dynamic> localUserData = jsonDecode(userDataString);
        setState(() {
          userData = localUserData;
          userNameFirst = userData?['firstName'] ?? "";
          userNameLast = userData?['lastName'] ?? "";
          userEmail = userData?['email'] ?? "";
          userGender = userData?['gender'] ?? "";
          userPhone = userData?['phone'] ?? "";
          _userProfileUrl = userData?['profileImageUrl'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile(Map<String, dynamic> updatedData) async {
    try {
      setState(() {
        userNameFirst = updatedData['firstName'] ?? userNameFirst;
        userNameLast = updatedData['lastName'] ?? userNameLast;
        userPhone = updatedData['phone'] ?? userPhone;
        userGender = updatedData['gender'] ?? userGender;
        _userProfileUrl = updatedData['profileImageUrl'] ?? _userProfileUrl;
      });

      final prefs = await SharedPreferences.getInstance();
      final currentData = userData ?? {};
      final newUserData = {
        ...currentData,
        ...updatedData,
      };
      await prefs.setString('userData', jsonEncode(newUserData));

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .update(updatedData);
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFF1F8E9),
        elevation: 4,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFF388E3C),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        toolbarHeight: 56,
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : RefreshIndicator(
        onRefresh: fetchUserData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              _buildProfileHeader(),
              SizedBox(height: 30),
              _sectionTitle("Personal Info"),
              _buildUserInfoSection(),
              SizedBox(height: 30),
              _sectionTitle("Settings"),
              _buildPreferencesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey[200],
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : (_userProfileUrl != null && _userProfileUrl!.isNotEmpty
                  ? NetworkImage(_userProfileUrl!) as ImageProvider
                  : null),
              child: (_profileImage == null &&
                  (_userProfileUrl == null || _userProfileUrl!.isEmpty))
                  ? Icon(Icons.person, size: 55, color: Colors.grey)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 4,
              child: GestureDetector(
                onTap: () async {
                  final updatedData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        firstName: userNameFirst,
                        lastName: userNameLast,
                        email: userEmail,
                        phone: userPhone,
                        gender: userGender,
                        currentImage: _userProfileUrl,
                        onSave: _updateProfile,
                      ),
                    ),
                  );
                  if (updatedData != null) {
                    _updateProfile(updatedData);
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Color(0xFF388E3C),
                  radius: 18,
                  child: Icon(Icons.edit, size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          "$userNameFirst $userNameLast",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
        SizedBox(height: 4),
        Text(
          userEmail,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Column(
      children: [
        _buildInfoCard('First Name', userNameFirst, Icons.person),
        _buildInfoCard('Last Name', userNameLast, Icons.person_outline),
        _buildInfoCard('Phone', userPhone, Icons.phone),
        _buildInfoCard('Email', userEmail, Icons.email),
        _buildInfoCard('Gender', userGender, Icons.wc),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF2E7D32)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Column(
      children: [
        _buildPreferenceItem('Rented Property', Icons.home, () {}),
        _buildPreferenceItem('Favourites', Icons.favorite, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritesScreen()),
          );
        }),
        _buildPreferenceItem('Location', Icons.location_on, () {}),
        _buildPreferenceItem('Logout', Icons.logout, _confirmLogout,
            iconColor: Colors.red),
      ],
    );
  }

  Widget _buildPreferenceItem(
      String label, IconData icon, VoidCallback onTap,
      {Color iconColor = const Color(0xFF388E3C)}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(label),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
