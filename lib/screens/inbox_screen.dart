import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maprojects/services/chat_service.dart';
import '../services/firestore_service.dart';
import 'chat_screen.dart';
import 'package:maprojects/models/user_tile.dart';

class InboxScreen extends StatefulWidget {
  final String currentUserId; // Add this parameter

  const InboxScreen({
    required this.currentUserId, // Mark as required
    Key? key,
  }) : super(key: key);

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final ChatService _chatService = ChatService();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _currentUserId;


  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Inbox",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // print("Firestore Stream Error: ${snapshot.error}");  // Debugging
          return Text("Error: ${snapshot.error}");
        }

        if (!snapshot.hasData || snapshot.data == null || (snapshot.data as List).isEmpty) {
          // print("Firestore Stream Returned No Users");  // Debugging
          return const Text("No users found.");
        }

        final users = snapshot.data as List<Map<String, dynamic>>;


        final filteredUsers = users.where((user) => user["uid"] != _currentUserId).toList();

        if (filteredUsers.isEmpty) {
          return const Text("No other users available.");
        }
        print(users);
        return ListView(
          children: filteredUsers.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
        );
      },
    );
  }


  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    return UserTile(
      text: "${userData["firstName"]} ${userData["lastName"]}",
      profileImageUrl: userData["profileImageUrl"],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(receiverEmail: userData["email"],
              receiverID: userData['uid'],
            ),
          ),
        );
      },
    );
  }
}
