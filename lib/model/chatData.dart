
import 'package:cloud_firestore/cloud_firestore.dart';
//definición de un modelo del chat para poder usarlo al sacar datos de Firestore

class ChatData {
  final String? chatId;
  final String? regularUserId;
  final String? shelterId;



  ChatData({
    this.chatId,
    this.regularUserId,
    this.shelterId,
  });

  factory ChatData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return ChatData(
      chatId: data?['chatId'],
      regularUserId: data?['regularUserId'],
      shelterId: data?['shelterId'],
    );
  } //metodo para obtener datos de firestore asignando cada dato de la base de datos a la variable definida en la clase

  Map<String, dynamic> toFirestore() {
    return {
      if (chatId != null) "chatId": chatId,
      if (regularUserId != null) "regularUserId": regularUserId,
      if (shelterId != null) "shelterId": shelterId,
    };
  }
} //metodo para enviar a firestore asignando de cada variable su correspondiente campo en la base de datos