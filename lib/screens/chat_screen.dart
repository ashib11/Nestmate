import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maprojects/services/auth_service.dart';
import 'package:maprojects/services/chat_service.dart';
import 'package:maprojects/widgets/chat_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  String _receiverName = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchReceiverName();
  }


  void _fetchReceiverName() async {
    try {
      print("Fetching name for user ID: ${widget.receiverID}"); // Debugging

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.receiverID)
          .get();

      if (userDoc.exists) {
        String firstName = userDoc["firstName"] ?? "";
        String lastName = userDoc["lastName"] ?? "";
        String fetchedName = "$firstName $lastName".trim();


        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("receiverName_${widget.receiverID}", fetchedName);

        setState(() {
          _receiverName = fetchedName;
        });
      } else {
        print("User document does not exist!");
        setState(() {
          _receiverName = widget.receiverEmail;
        });
      }
    } catch (e) {
      print("Error fetching name: $e");
      setState(() {
        _receiverName = widget.receiverEmail;
      });
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_receiverName),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Firestore Error: ${snapshot.error}");
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("L o a d i n g ...");
        } else {
          return ListView(
            children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
        }
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
