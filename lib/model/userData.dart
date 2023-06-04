import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String? uid;
  final String? name;
  final String? description;
  final String? email;
  final String? profilePicture;
  final List<String>? gallery;
  final List<String>? favourites;
  final bool? isShelter;

  UserData({
    this.uid,
    this.name,
    this.description,
    this.email,
    this.profilePicture,
    this.gallery,
    this.favourites,
    this.isShelter,
  });

  factory UserData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserData(
      uid: data?['uid'],
      name: data?['name'],
      description: data?['description'],
      email: data?['email'],
      profilePicture: data?['profilePicture'],
      gallery:
      data?['gallery'] is Iterable ? List.from(data?['gallery']) : null,
      favourites:
      data?['favourites'] is Iterable ? List.from(data?['favourites']) : null,
      isShelter: data?['isShelter'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (email != null) "email": email,
      if (profilePicture != null) "profilePicture": profilePicture,
      if (gallery != null) "gallery": gallery,
      if (favourites != null) "favourites": favourites,
      if (isShelter != null) "isShelter": isShelter,
    };
  }
}
