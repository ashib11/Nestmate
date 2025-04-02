import 'package:flutter/material.dart';


class ChatBubble extends StatelessWidget {
  final String message; 
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      decoration: BoxDecoration(
        color: isCurrentUser ?  Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(22)
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical:10 , horizontal:25 ),
      child: Text(message,
      style: TextStyle(color: Colors.white),),
    );
  }
}