import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderid;
  final String senderemail;
  final String reciverid;
  final String message;
  final Timestamp timestamp;


  Message({
    required this.senderid,
    required this.senderemail,
    required this.reciverid,
    required this.message,
    required this.timestamp
});

  Map<String,dynamic> toMap(){
    return {
      'senderid':senderid,
      'senderemail':senderemail,
      'reciverid':reciverid,
      'message':message,
      'timestamp':timestamp
    };

  }
}
