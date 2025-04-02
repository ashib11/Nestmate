import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? profileImageUrl;
  final DateTime createdAt;

  ChatUser({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.profileImageUrl,
    required this.createdAt,
  });

  factory ChatUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ChatUser(
      uid: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'],
      profileImageUrl: data['profileImageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class ChatMessage {
  final String chatId;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isSentByMe;

  ChatMessage({
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isSentByMe,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ChatMessage(
      chatId: data['chatId'] ?? '',
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isSentByMe: data['isSentByMe'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isSentByMe': isSentByMe,
    };
  }
}