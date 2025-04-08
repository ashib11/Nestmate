import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/chat_service.dart';
import '../services/firestore_service.dart';
import 'chat_screen.dart';
import '../models/user_tile.dart';

class InboxScreen extends StatefulWidget {
  final String currentUserId;

  const InboxScreen({
    required this.currentUserId,
    Key? key,
  }) : super(key: key);

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _currentUserId;
  List<Map<String, dynamic>> _cachedUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser?.uid ?? widget.currentUserId;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // 1. Try to load from cache first
    await _loadFromCache();

    // 2. Fetch fresh data from Firestore
    await _fetchLatestUsers();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('inbox_users');

      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        setState(() {
          _cachedUsers = jsonList.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print("Error loading from cache: $e");
    }
  }

  Future<void> _fetchLatestUsers() async {
    try {
      final users = await _chatService.getUserStream().first;

      // Filter out current user
      final filteredUsers = users.where((user) => user["uid"] != _currentUserId).toList();

      // Update cache
      await _saveToCache(filteredUsers);

      setState(() {
        _cachedUsers = filteredUsers;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Couldn't refresh user list. Showing cached data.";
      });
      print("Error fetching users: $e");
    }
  }

  Future<void> _saveToCache(List<Map<String, dynamic>> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('inbox_users', jsonEncode(users));
    } catch (e) {
      print("Error saving to cache: $e");
    }
  }

  Widget _buildUserList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _cachedUsers.isEmpty) {
      return Center(child: Text(_errorMessage!));
    }

    if (_cachedUsers.isEmpty) {
      return const Center(child: Text("No users available."));
    }

    return RefreshIndicator(
      onRefresh: _fetchLatestUsers,
      child: ListView(
        children: _cachedUsers
            .map<Widget>((userData) => _buildUserListItem(userData, context))
            .toList(),
      ),
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
            builder: (context) => ChatScreen(
              receiverEmail: userData["email"],
              receiverID: userData['uid'],
            ),
          ),
        );
      },
    );
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
      body: Container(
        color: const Color(0xFFFAF5EF),
        child: _buildUserList(),
      ),
    );
  }
}