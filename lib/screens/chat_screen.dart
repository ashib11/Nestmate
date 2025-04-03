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
      body: Container(
       color:  const Color(0xFFFAF5EF),
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildUserInput(),
          ],
        ),
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
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left:20, bottom: 2, right: 1, top:  5),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green[50], // Light background for contrast
                borderRadius: BorderRadius.circular(40), // Rounded corners
                border: Border.all(color: Colors.grey[400]!), // Subtle border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null, // Expands as user types
                keyboardType: TextInputType.multiline, // Allows multi-line input
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            // decoration: const BoxDecoration(
            //   color: Colors.grey,
            //   shape: BoxShape.circle,
            // ),
            margin: const EdgeInsets.only(left: 1,right: 6, bottom: 4,),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send, color: Colors.green, size: 30,),
            ),
          ),
        ],
      ),
    );
  }

}
