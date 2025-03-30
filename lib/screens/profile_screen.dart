import 'package:firestore_cache/firestore_cache.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'editProfile_screen.dart';
import 'favorites_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      DocumentSnapshot<Map<String, dynamic>>
      userDoc = await FirestoreCache.getDocument(
        FirebaseFirestore.instance.collection('users').doc(widget.userID),
      );

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
          userNameFirst = userData?['firstName'] ?? "";
          userNameLast = userData?['lastName'] ?? "";
          userEmail = userData?['email'] ?? "";
          userGender = userData?['gender'] ?? "";
          userPhone = userData?['phone'] ?? "";
          userData?['profileImageUrl'] ?? "";
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateProfile(Map<String, dynamic> updatedData) {
    setState(() {
      userNameFirst = updatedData['firstName'] ?? userNameFirst;
      userNameLast = updatedData['lastName'] ?? userNameLast;
      userPhone = updatedData['phone'] ?? userPhone;
      userGender = updatedData['gender'] ?? userGender;
      _profileImage = updatedData['image'] ?? _profileImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            _buildUserInfoSection(),
            _buildPreferencesSection(),
            // _buildActionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green[100],
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) // Show locally picked image
                    : (userData?['profileImageUrl'] != null &&
                    userData?['profileImageUrl'].isNotEmpty
                    ? NetworkImage(userData?['profileImageUrl']) // Show Cloudinary image
                    : null),
                child: (_profileImage == null &&
                    (userData?['profileImageUrl'] == null ||
                        userData?['profileImageUrl'].isEmpty))
                    ? Icon(Icons.person, size: 50, color: Colors.green[800])
                    : null,
              ),
              GestureDetector(
                onTap: () async {
                  final updatedData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditProfileScreen(
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
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green[800],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$userNameFirst $userNameLast',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  userEmail,
                  style: TextStyle(color: Colors.green[600], fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Your Information',
          //   style: TextStyle(
          //     color: Colors.green,
          //     fontSize: 20,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // SizedBox(height: 10),
          _buildInfoCard('First Name', userNameFirst),
          _buildInfoCard('Last Name', userNameLast),
          _buildInfoCard('Phone Number', userPhone),
          _buildInfoCard('Email Address', userEmail),
          _buildInfoCard('Gender', userGender),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences',
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _buildPreferenceItem('Rented Property', Icons.home),
          _buildPreferenceItem('Favourites', Icons.favorite),
          _buildPreferenceItem('Language', Icons.language),
          _buildPreferenceItem('Location', Icons.location_on),
          _buildActionItem('Logout', Icons.logout),
        ],
      ),
    );
  }

  // Widget _buildActionsSection() {
  //   return Padding(
  //     padding: EdgeInsets.all(20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Actions',
  //           style: TextStyle(
  //             color: Colors.green,
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         SizedBox(height: 10),
  //         _buildActionItem('Clear Cache', Icons.cached),
  //         _buildActionItem('Clear History', Icons.history),
  //         _buildActionItem('Logout', Icons.logout),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(String label, IconData icon) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(label, style: TextStyle(color: Colors.black, fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {
          if (label == 'Favourites') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildActionItem(String label, IconData icon) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(label, style: TextStyle(color: Colors.black, fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {},
      ),
    );
  }
}
