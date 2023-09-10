// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String? senderPhoto;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  Message({
    required this.senderId,
    required this.senderPhoto,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });
  //TODO Create Chat Service Using Provider Data

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'senderPhoto': senderPhoto,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  
}
