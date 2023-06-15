import 'package:cloud_firestore/cloud_firestore.dart';
//definición de un modelo de perro para poder usarlo al sacar datos de Firestore

class DogData {
  final String? dogId;
  final String? name;
  final String? breed;
  final String? sex;
  final int? age;
  final String? description;
  final String? shelterId;
  final String? profilePicture;


  DogData({
    this.dogId,
    this.name,
    this.breed,
    this.sex,
    this.age,
    this.description,
    this.shelterId,
    this.profilePicture,
  });

  factory DogData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return DogData(
      dogId: data?['dogId'],
      name: data?['name'],
      breed: data?['breed'],
      sex: data?['sex'],
      age: data?['age'],
      description: data?['description'],
      shelterId: data?['shelterId'],
      profilePicture: data?['profilePicture'],
    );
  } //metodo para obtener datos de firestore asignando cada dato de la base de datos a la variable definida en la clase

  Map<String, dynamic> toFirestore() {
    return {
      if (dogId != null) "dogId": dogId,
      if (name != null) "name": name,
      if (breed != null) "breed": breed,
      if (sex != null) "sex": sex,
      if (age != null) "age": age,
      if (description != null) "description": description,
      if (shelterId != null) "shelterId": shelterId,
      if (profilePicture != null) "profilePicture": profilePicture,
    };
  }
} //metodo para enviar a firestore asignando de cada variable su correspondiente campo en la base de datos