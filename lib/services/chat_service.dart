import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myflutterproject/models/message.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList(); // Convert the iterable to a list
    });
  }

  Future<void> sendMessage(String reciverID, message)async {
    final String currentUserId=_auth.currentUser!.uid;
    final String currentUserEmail=_auth.currentUser!.email!;
    final Timestamp timestamp=Timestamp.now();
     Message newMessage= Message(
    senderid: currentUserId,
    senderemail: currentUserEmail,
    reciverid: reciverID,
    message: message,
    timestamp: timestamp);
// Construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, reciverID];
    ids.sort(); // sort the ids (this ensures the chatRoomID is the same for any 2 people)
    String chatRoomID = ids.join('_');

// Add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
    // Get messages






  }
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // Construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

}
