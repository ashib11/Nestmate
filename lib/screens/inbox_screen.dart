import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  final List<Chat> chats = [
    Chat(
      name: "Sadia Sultana Enami",
      message: "Flat booking is going on...",
      time: "2:44 pm",
      profileImage: null,
    ),
    Chat(
      name: "Tamanna Alam Tabashom",
      message: "Is this flat still available?",
      time: "1:30 pm",
      profileImage: "https://example.com/images/user2.jpg",
    ),
    Chat(
      name: "Kamrujjaman Rifat",
      message: "Can I visit tomorrow?",
      time: "1:15 am",
      profileImage: "https://example.com/images/user3.jpg",
    ),
    Chat(
      name: "Ashibur Rahman",
      message: "I will pay you advance.",
      time: "3:15 am",
      profileImage: null,
    ),
    Chat(
      name: "Tanvir Rahman Shuvro",
      message: "Not available",
      time: "11:13 am",
      profileImage: "https://example.com/images/user5.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Inbox",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return InkWell(
            onTap: () {
              // Navigate to ChatScreen when a chat item is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chat: chat),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: chat.profileImage != null
                        ? NetworkImage(chat.profileImage!)
                        : const AssetImage('assets/default_profile.png') as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat.message,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    chat.time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [
    Message(text: "Hello! Is the flat still available?", isSentByMe: false),
    Message(text: "Yes, it is available.", isSentByMe: true),
    Message(text: "Can I visit tomorrow?", isSentByMe: false),
    Message(text: "Sure, you can visit anytime after 10 AM.", isSentByMe: true),
  ];

  final TextEditingController messageController = TextEditingController();

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(Message(text: text, isSentByMe: true));
        messageController.clear();
        // Simulate a reply
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            messages.add(Message(text: "Thank you!", isSentByMe: false));
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.chat.profileImage != null
                  ? NetworkImage(widget.chat.profileImage!)
                  : const AssetImage('assets/default_profile.png') as ImageProvider,
            ),
            const SizedBox(width: 8),
            Text(
              widget.chat.name,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return Align(
                  alignment: message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: message.isSentByMe ? Colors.green : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isSentByMe ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Open emoji picker (to be implemented)
                  },
                  icon: const Icon(Icons.emoji_emotions, color: Colors.orange),
                ),
                IconButton(
                  onPressed: () {
                    // Open camera/gallery (to be implemented)
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.blue),
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Chat {
  final String name;
  final String message;
  final String time;
  final String? profileImage;

  Chat({
    required this.name,
    required this.message,
    required this.time,
    this.profileImage,
  });
}

class Message {
  final String text;
  final bool isSentByMe;

  Message({required this.text, required this.isSentByMe});
}
