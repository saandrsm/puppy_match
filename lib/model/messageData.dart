import 'package:cloud_firestore/cloud_firestore.dart';
//definición de un modelo de usuario para poder usarlo al sacar datos de Firestore

class MessageData {
  final String? chatId;
  final String? senderId;
  final String? text;
  final Timestamp? time;


  MessageData({
    this.chatId,
    this.senderId,
    this.text,
    this.time
  });

  factory MessageData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return MessageData(
      chatId: data?['chatId'],
      senderId: data?['senderId'],
      text: data?['text'],
      time: data?['time'],
    );
  } //metodo para obtener datos de firestore asignando cada dato de la base de datos a la variable definida en la clase

  Map<String, dynamic> toFirestore() {
    return {
      if (chatId != null) "chatId": chatId,
      if (senderId != null) "senderId": senderId,
      if (text != null) "text": text,
      if (time != null) "time": time,
    };
  }
} //metodo para enviar a firestore asignando de cada variable su correspondiente campo en la base de datos