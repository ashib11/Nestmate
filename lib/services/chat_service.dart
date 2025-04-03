import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maprojects/models/msg_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch all users WITH their UID included in the data
  // In ChatService class
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => {
      'uid': doc.id,
      'firstName': doc['firstName'],
      'lastName': doc['lastName'],
      'email': doc['email'],
      'profileImageUrl': doc['profileImageUrl'],
    })
        .toList());
  }

  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String? currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();


    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail??"",
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);


    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    await _firestore.collection("chat_room").doc(chatRoomID).collection("messages").add(newMessage.toMap());

  }

Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_room")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();

}

}
