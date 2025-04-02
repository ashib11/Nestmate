import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maprojects/models/chat_model.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user data
  Stream<ChatUser> getUserData(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => ChatUser.fromFirestore(snapshot));
  }

  // Get all users (for inbox list)
  Stream<List<ChatUser>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ChatUser.fromFirestore(doc)).toList();
    });
  }

  // Get messages for a chat
  Stream<QuerySnapshot> getMessages(String user1Id, String user2Id) {
    final chatId = generateChatId(user1Id, user2Id);
    return _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
  String generateChatId(String uid1, String uid2) {
    return uid1.compareTo(uid2) < 0 ? '$uid1-$uid2' : '$uid2-$uid1';
  }

  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    await _firestore.collection('messages').add({
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'isSentByMe': true,
    });
  }

  // Create or update user data
  Future<void> updateUserData(ChatUser user) {
    return _firestore.collection('users').doc(user.uid).set(user.toMap());
  }
}